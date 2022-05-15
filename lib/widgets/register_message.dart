import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../dialogs/new_user_dialog.dart';

class RegisterMessage extends StatefulWidget {
  const RegisterMessage({Key? key}) : super(key: key);

  @override
  _RegisterMessageState createState() => _RegisterMessageState();
}

class _RegisterMessageState extends State<RegisterMessage> {
  final TextStyle normalStyle = const TextStyle(color: Colors.grey);
  final TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline
  );

  void signUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const NewUserDialog();
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    TapGestureRecognizer signUpClicked = TapGestureRecognizer();
    signUpClicked.onTap = () => signUpDialog(context);

    return RichText(
        text: TextSpan(
            style: normalStyle,
            children: [
              const TextSpan(text: "New user? "),
              TextSpan(text: "Sign up", style: linkStyle, recognizer: signUpClicked),
              const TextSpan(text: " today!")
            ]
        )
    );
  }
}