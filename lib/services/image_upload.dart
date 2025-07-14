import 'dart:io';
import 'package:image_picker/image_picker.dart';
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
}
