import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/models/my_user.dart';

class AuthController extends GetxController {
  Future<String> uploadToStorage(String uid, File file) async {
    try {
      Reference ref =
          FirebaseStorage.instance.ref().child('profiles').child(uid);
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snap = await uploadTask;
      String url = await snap.ref.getDownloadURL();
      return url;
    } catch (e) {
      Get.snackbar('error', e.toString());
      return '';
    }
  }

  Future<void> login(String email, String password) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .get();

      MyUser.instance =
          MyUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }

  Future setInitialModel() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        MyUser.instance =
            MyUser.fromJson(documentSnapshot.data() as Map<String, dynamic>);
      }
    } catch (e) {
      Get.snackbar('error', 'error');
    }
  }

  register(String username, String password, String email, File? file) async {
    try {
      if (username.isNotEmpty ||
          password.isNotEmpty ||
          email.isNotEmpty ||
          file != null) {
        UserCredential cred = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String profileUrl = await uploadToStorage(cred.user!.uid, file!);

        MyUser.instance = MyUser(
            uid: cred.user!.uid,
            username: username,
            email: email,
            profileUrl: profileUrl);

        FirebaseFirestore.instance
            .collection('users')
            .doc(cred.user!.uid)
            .set(MyUser.instance!.toJson());

        await login(email, password);
      } else {
        Get.snackbar('UI error', 'fill all the fields');
      }
    } catch (e) {
      Get.snackbar('error', e.toString());
    }
  }
}
