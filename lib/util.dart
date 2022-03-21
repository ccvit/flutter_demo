import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// == styles ==
const TextStyle errorStyle = TextStyle(color: Colors.red);


// == Widgets ==
Widget buildTextField({required String hint, required TextEditingController textEditingController, required bool obscureText}) {
  return TextField(
    obscureText: obscureText,
    controller: textEditingController,
    decoration: InputDecoration(
      border: const UnderlineInputBorder(),
      hintText: hint,
    ),
  );
}

class Util {

}