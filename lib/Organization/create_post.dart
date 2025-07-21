import 'dart:io';
import 'package:flutter/material.dart';
import '../services/authentication.dart';
import '../services/image_upload.dart';
import '../services/posting.dart';
import '../widget/app_bar.dart';
import '../widget/empty_box.dart';
import '../widget/question_box.dart';
import '../widget/response_dialog.dart';
import '../widget/side_bar.dart';

class CreatePostPage extends StatefulWidget {
  @override
  _CreatePostPageState createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final AuthenticationService _authService = AuthenticationService();
  final ImageUploadService _service = ImageUploadService();
  bool isLoading = true;
  String? id;
  List<String> _uploadedUrls = [];
  final titleController = TextEditingController();
  final descController = TextEditingController();
  String? titleError;
  String? descError;

  void initState() {
    super.initState();
    fetchID();
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  Future<void> fetchID() async {
    final fetchedCid = await _authService.getCurrentUserID();
    setState(() {
      id = fetchedCid;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'Create Post', type: 1),
      drawerEnableOpenDragGesture: false,
      drawer: OrganizationSideBar(userId: id),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  QuestionBox(
                    label: 'Title',
                    hint: 'Enter your title',
                    controller: titleController,
                    errorText: titleError,
                  ),
                  gaph16,
                  QuestionBox(
                    label: 'Description:',
                    hint: 'Enter your post\'s description',
                    maxline: 10,
                    controller: descController,
                    errorText: descError,
                  ),
                  gaph24,
                  Text('Selected Images:'),
                  gaph8,
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _service.pendingImages.asMap().entries.map((
                        entry,
                      ) {
                        final idx = entry.key;
                        final file = entry.value;
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 8),
                              width: 100,
                              height: 100,
                              child: Image.file(
                                File(file.path),
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _service.removePendingImage(idx);
                                });
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                  gaph32,
                  ElevatedButton.icon(
                    onPressed: () async {
                      await _service.addPendingImage();
                      setState(() {});
                    },
                    icon: Icon(Icons.photo_library),
                    label: Text('Pick Image'),
                  ),
                  gaph32,
                  ElevatedButton.icon(
                    onPressed: () async {
                      _createPost();
                    },
                    icon: Icon(Icons.upload),
                    label: Text('Confirm Upload'),
                  ),
                ],
              ),
            ),
    );
  }

  Future<void> _createPost() async {
    if (validateInputs()) {
      try {
        final postId = await createPost(
          oid: id!,
          title: titleController.text,
          description: descController.text,
        );

        if (postId != null) {
          final urls = await _service.confirmAndUploadAll(postId);
          setState(() {
            _uploadedUrls = urls;
          });
          try {
            await addMediaLinks(postId: postId, links: _uploadedUrls);
            titleController.clear();
            descController.clear();
            showDialog(
              context: context,
              builder: (context) => ResponseDialog(
                title: 'Success',
                message: 'Successfully created the post',
                type: true,
              ),
            );
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) => ResponseDialog(
                title: 'Error',
                message: 'Exception: $e',
                type: false,
              ),
            );
          }
        } else {
          showDialog(
            context: context,
            builder: (context) => ResponseDialog(
              title: 'Error',
              message: 'Failed to create post',
              type: false,
            ),
          );
        }
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => ResponseDialog(
            title: 'Error',
            message: 'Failed: $e',
            type: false,
          ),
        );
      }
    }
  }

  bool validateInputs() {
    final confirmTitle = titleController.text;
    final confirmDescription = descController.text;

    setState(() {
      titleError = confirmTitle.length >= 5
          ? null
          : 'Name must be at least 5 characters';
      descError = confirmDescription.isNotEmpty
          ? null
          : 'Description must not be empty';
    });
    if (titleError != null || descError != null) {
      Future.delayed(Duration(seconds: 1), () {
        if (mounted) {
          setState(() {
            titleError = null;
            descError = null;
          });
        }
      });
    }

    return titleError == null && descError == null;
  }
}
