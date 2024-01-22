import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'confirm_screen.dart';

class AddVideoScreen extends StatelessWidget {
  const AddVideoScreen({super.key});

  Future _takeVideo(ImageSource src, BuildContext context) async {
    XFile? xFile = await ImagePicker().pickVideo(source: src);
    if (xFile != null) {
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmScreen(xFile),
        ),
      );
    }
  }

  _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _takeVideo(ImageSource.gallery, context);
                },
                child: Row(
                  children: [
                    Icon(Icons.image),
                    Text(
                      '  Gallery',
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  _takeVideo(ImageSource.camera, context);
                },
                child: Row(
                  children: [
                    Icon(Icons.camera_enhance_rounded),
                    Text(
                      '  Camera',
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    Icon(Icons.close),
                    Text(
                      '  Cancel',
                      style: TextStyle(fontSize: 26),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          _showDialog(context);
        },
        child: Text(
          'Upload a Video',
        ),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
      ),
    );
  }
}
