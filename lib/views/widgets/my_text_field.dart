import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  const MyTextField(
      {required this.hintText,
      required this.hintIcon,
      required this.textEditingController,
      this.isPass = false,
      super.key});
  final String hintText;
  final Icon hintIcon;
  final bool isPass;
  final TextEditingController textEditingController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: TextField(
        controller: textEditingController,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: hintIcon,
          border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.white)),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.red)),
        ),
        obscureText: isPass,
      ),
    );
  }
}
