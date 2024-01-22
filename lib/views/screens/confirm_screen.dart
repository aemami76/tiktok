import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/controllers/upload_video_controller.dart';
import 'package:video_player/video_player.dart';

class ConfirmScreen extends StatefulWidget {
  const ConfirmScreen(this.xfile, {super.key});
  final XFile xfile;

  @override
  State<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  late VideoPlayerController videoPlayerController;
  final textEditingController = TextEditingController();
  final uploadVideoController = UploadVideoController();

  @override
  void initState() {
    super.initState();
    setState(() {
      videoPlayerController =
          VideoPlayerController.file(File(widget.xfile.path));
    });
    videoPlayerController.initialize();
    videoPlayerController.play();
    videoPlayerController.setLooping(true);
  }

  @override
  void dispose() {
    textEditingController.dispose();
    videoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('>>>>  ' + widget.xfile.path);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 40,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height - 200,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: VideoPlayer(videoPlayerController),
                )),
            SizedBox(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: TextField(
                    controller: textEditingController,
                    decoration: const InputDecoration(
                        labelText: 'Description', border: OutlineInputBorder()),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: () async {
                  videoPlayerController.dispose();
                  await uploadVideoController.uploadVideo(
                      textEditingController.text, widget.xfile);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: Center(
                    child: Text(
                      'Share',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
