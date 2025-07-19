import 'dart:io';
import 'package:fypapp2/services/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();

  final List<XFile> _pendingImages = [];

  List<XFile> get pendingImages => List.unmodifiable(_pendingImages);

  Future<XFile?> addPendingImage() async {
    final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      _pendingImages.add(file);
    }
    return file;
  }

  void removePendingImage(int index) {
    if (index >= 0 && index < _pendingImages.length) {
      _pendingImages.removeAt(index);
    }
  }

  Future<String> uploadImage(XFile imageFile, String POD) async {
    try {
      final bytes = await File(imageFile.path).readAsBytes();
      final fileName =
          '$POD/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';

      await _supabase.storage
          .from('post')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: 'image/jpeg'),
          );

      final String publicUrl = _supabase.storage
          .from('post')
          .getPublicUrl(fileName);

      return publicUrl;
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  Future<List<String>> confirmAndUploadAll(String POD) async {
    final uploads = <Future<String>>[];
    for (final img in _pendingImages) {
      uploads.add(uploadImage(img, POD));
    }
    final results = await Future.wait(uploads);
    _pendingImages.clear();
    return results;
  }

  Future<void> ProfileImg(String id, bool type) async {
    final SupabaseClient supabase = Supabase.instance.client;
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file == null) {
        print('No image selected.');
        return;
      }

      final allowedExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp'];
      final extension = file.name.toLowerCase();
      if (!allowedExtensions.any((ext) => extension.endsWith(ext))) {
        print(
          'Only image files (${allowedExtensions.join(', ')}) are allowed.',
        );
        return;
      }

      final bytes = await File(file.path).readAsBytes();
      final String fileName = '$id/${type ? 'profile' : 'background'}';

      final mimeType = lookupMimeType(file.path) ?? 'image/jpeg';

      final existingFiles = await supabase.storage
          .from('profile')
          .list(path: id);
      for (final f in existingFiles) {
        if (f.name == (type ? 'profile' : 'background')) {
          await supabase.storage.from('profile').remove(['$fileName']);
          break;
        }
      }

      await supabase.storage
          .from('profile')
          .uploadBinary(
            fileName,
            bytes,
            fileOptions: FileOptions(contentType: mimeType, upsert: true),
          );

      final String publicUrl = supabase.storage
          .from('profile')
          .getPublicUrl(fileName);

      try {
        final updatedUser = await changeProfileImage(
          type: type,
          id: id,
          url: publicUrl,
        );
        print('User updated: $updatedUser');
      } catch (e) {
        print('Error: $e');
      }

      print('Image uploaded: $publicUrl');
    } catch (e) {
      print('Upload failed: $e');
    }
  }
}
