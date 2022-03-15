import 'package:example_cpl/database/db.dart';
import 'package:flutter/material.dart';

import '../hub_screen.dart';
import '../util.dart';

class NewUser extends StatefulWidget {
  const NewUser({Key? key}) : super(key: key);

  @override
  _NewUserState createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {

  // credential controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextStyle errorStyle = const TextStyle(color: Colors.red);

  RegisterType? registerType;
  submit() async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;
    String confirmPassword = _confirmPasswordController.value.text;
    if (password == confirmPassword) {
      DatabaseProvider provider = DatabaseProvider();
      registerType = await provider.createUser(username: username, password: password);
      if (registerType == RegisterType.succeeded) {
        Navigator.of(context).pop();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Hub(username)),
        );
      }
    } else {
      registerType = RegisterType.passwordFail;
    }
    setState((){});

  }

  cancel() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // Base children. will always appear
    List<Widget> registerChildren = [
      buildTextField(
          obscureText: false,
          hint: "Username",
          textEditingController: _usernameController
      ),
      buildTextField(
          obscureText: true,
          hint: "Password",
          textEditingController: _passwordController
      ),
      buildTextField(
          obscureText: true,
          hint: "Confirm password",
          textEditingController: _confirmPasswordController
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(onPressed: cancel, child: const Text("Cancel")),
            ElevatedButton(onPressed: submit, child: const Text("Submit")),
          ],
        ),
      )
    ];
    // error children
    if (registerType == RegisterType.passwordFail) {
      registerChildren.add(Text("Passwords do not match", style: errorStyle,));
    } else if (registerType == RegisterType.userExists) {
      registerChildren.add(Text("User already exists", style: errorStyle,));
    }

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: registerChildren
        ),
      ),
    );
  }
}
