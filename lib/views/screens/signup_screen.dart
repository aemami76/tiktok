import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/views/widgets/my_text_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _eController = TextEditingController();
  final _pController = TextEditingController();
  final _uController = TextEditingController();
  File? img;

  void getPicture() async {
    XFile? xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) {
      return;
    }
    setState(() {
      img = File(xFile.path);
    });
  }

  @override
  void dispose() {
    _uController.dispose();
    _eController.dispose();
    _pController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: Get.height / 8,
            ),
            const Text(
              "TIKTOK CLONE\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 35, color: Colors.red),
            ),
            const Text(
              "Sign Up",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: img == null
                      ? const CircleAvatar(
                          backgroundColor: Colors.white38,
                          radius: 50,
                          child: Icon(
                            Icons.person,
                            size: 80,
                          ),
                        )
                      : CircleAvatar(
                          backgroundImage: FileImage(img!),
                          backgroundColor: Colors.white38,
                          radius: 50,
                        ),
                ),
                Positioned(
                    bottom: -10,
                    right: Get.width / 2 - 50,
                    child: IconButton(
                        onPressed: getPicture,
                        icon: const Icon(Icons.add_a_photo_rounded)))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextField(
                hintText: 'Username',
                hintIcon: const Icon(Icons.person),
                textEditingController: _uController),
            MyTextField(
                hintText: 'Email',
                hintIcon: const Icon(Icons.email_outlined),
                textEditingController: _eController),
            MyTextField(
              hintText: "Password",
              hintIcon: const Icon(Icons.lock),
              textEditingController: _pController,
              isPass: true,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
              child: ElevatedButton(
                onPressed: () async {
                  await AuthController().register(_uController.text,
                      _pController.text, _eController.text, img);
                  if (FirebaseAuth.instance.currentUser != null) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Sign Up'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('I already have an account '),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
