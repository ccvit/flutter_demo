import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final Function onPressAction;
  const LoginButton({required this.onPressAction, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
          child: ElevatedButton(
              onPressed: (){
                onPressAction(context);
              },
              child: const Text("Login")
          )
      ),
    );
  }
}
