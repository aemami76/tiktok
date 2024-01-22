import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiktok_clone/controllers/auth_controller.dart';
import 'package:tiktok_clone/views/screens/signup_screen.dart';
import 'package:tiktok_clone/views/widgets/my_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _eController = TextEditingController();
  final _pController = TextEditingController();

  @override
  void dispose() {
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
              height: Get.height / 5,
            ),
            const Text(
              "TIKTOK CLONE\n\n",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 35, color: Colors.red),
            ),
            const Text(
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 30,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
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
                onPressed: () {
                  AuthController().login(_eController.text, _pController.text);
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Sign In'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('I dont\' have an account '),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignUpScreen()));
                  },
                  child: const Text(
                    'Register',
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
