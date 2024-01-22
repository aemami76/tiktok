import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/models/my_user.dart';
import 'package:video_compress/video_compress.dart';

class UploadVideoController {
  Future<File> _thumbnailVideo(XFile xFile) async {
    var thumbnail = await VideoCompress.getFileThumbnail(xFile.path);
    return thumbnail;
  }

  Future<File> _compressedVideo(XFile xFile) async {
    try {
      var mediaInfo = await VideoCompress.compressVideo(xFile.path,
          quality: VideoQuality.LowQuality);
      var newFile = mediaInfo?.file;
      return newFile!;
    } catch (e) {
      Get.snackbar('error', e.toString());
      return File(xFile.path);
    }
  }

  uploadVideo(String caption, XFile xFile) async {
    try {
      final user = MyUser.instance!;
      QuerySnapshot<Map<String, dynamic>> allDoc =
          await FirebaseFirestore.instance.collection('videos').get();
      int len = allDoc.size;

      File cmpFile = await _compressedVideo(xFile);
      File thumb = await _thumbnailVideo(xFile);

      Reference ref =
          FirebaseStorage.instance.ref().child('video $len').child(user.uid);
      TaskSnapshot snap1 = await ref.putFile(cmpFile);
      String thumbUrl = await snap1.ref.getDownloadURL();

      Reference refT =
          FirebaseStorage.instance.ref().child('thumb $len').child(user.uid);
      TaskSnapshot snap2 = await refT.putFile(thumb);
      String videoUrl = await snap2.ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('videos')
          .doc('video $len')
          .set({
        'userId': user.uid,
        'videoID': 'video $len',
        'username': user.username,
        'profileUrl': user.profileUrl,
        'thumbUrl': thumbUrl,
        'videoUrl': videoUrl,
        'caption': caption,
        'like': [],
        'nComments': 0,
        'nShared': 0,
      });
      Get.snackbar('success', 'video uploaded!');
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }
}
