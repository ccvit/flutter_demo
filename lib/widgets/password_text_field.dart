import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PasswordTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;

  const PasswordTextField({required this.textEditingController, required this.hintText, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: TextField(
          obscureText: true,
          controller: textEditingController,
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            hintText: hintText,
          ),
        )
    );
  }
}
