import 'package:example_cpl/blocs/do_registration.dart';
import 'package:example_cpl/database/db.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/login_bloc.dart';
import '../blocs/registration_bloc.dart';
import '../planet_database_screen.dart';
import '../util.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({Key? key}) : super(key: key);

  @override
  _NewUserDialogState createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {

  // credential controllers
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextStyle errorStyle = const TextStyle(color: Colors.red);
  final RegisterBloc _registerBloc = RegisterBloc();

  submit() async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;
    String confirmPassword = _confirmPasswordController.value.text;

    DoRegistration doRegistration = DoRegistration(username, password, confirmPassword);
    _registerBloc.add(doRegistration);
  }

  cancel() {
    Navigator.of(context).pop();
  }

  checkRegisterAttempt(BuildContext context, RegisterType registerAttempt) {
    if (registerAttempt == RegisterType.succeeded) {
      Navigator.of(context).pop();
      Navigator.of(context).push<void>(PlanetDatabase.route(),);
    }
  }

  Widget buildDialogBottomRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(onPressed: cancel, child: const Text("Cancel")),
          ElevatedButton(onPressed: submit, child: const Text("Submit")),
        ],
      ),
    );
  }

  addErrorMessageIfNeeded(List<Widget> children, RegisterType registerAttempt) {
    if (registerAttempt == RegisterType.passwordFail) {
      children.add(Text("Passwords do not match", style: errorStyle,));
    } else if (registerAttempt == RegisterType.userExists) {
      children.add(Text("User already exists", style: errorStyle,));
    }
  }

  Widget buildRegistrationChildren(BuildContext context, RegisterType registerAttempt) {
    Widget usernameTextBox = buildTextField(
        obscureText: false,
        hint: "Username",
        textEditingController: _usernameController
    );

    Widget passwordTextBox = buildTextField(
        obscureText: true,
        hint: "Password",
        textEditingController: _passwordController

    );

    Widget confirmPasswordTextBox = buildTextField(
        obscureText: true,
        hint: "Confirm password",
        textEditingController: _confirmPasswordController
    );

    Widget dialogBottomRow = buildDialogBottomRow();

    List<Widget> children = [
      usernameTextBox,
      passwordTextBox,
      confirmPasswordTextBox,
      dialogBottomRow
    ];
    addErrorMessageIfNeeded(children, registerAttempt);

    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: BlocListener<RegisterBloc, RegisterType>(
          bloc: _registerBloc,
          listener: checkRegisterAttempt,
          child: BlocBuilder<RegisterBloc, RegisterType>(
            bloc: _registerBloc,
            builder: buildRegistrationChildren
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _registerBloc.close();
    super.dispose();
  }
}
