import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UsernameTextField  extends StatelessWidget {
  final TextEditingController textEditingController;
  const UsernameTextField ({required this.textEditingController, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: const InputDecoration(
        border: UnderlineInputBorder(),
        hintText: "Username",
      ),
    );
  }
}
