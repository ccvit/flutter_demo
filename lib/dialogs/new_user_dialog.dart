import 'package:example_cpl/blocs/do_registration.dart';
import 'package:example_cpl/widgets/dialog_bottom_row.dart';
import 'package:example_cpl/widgets/password_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/registration_bloc.dart';
import '../planet_database_screen.dart';
import '../widgets/username_text_field.dart';

class NewUserDialog extends StatefulWidget {
  const NewUserDialog({Key? key}) : super(key: key);

  @override
  _NewUserDialogState createState() => _NewUserDialogState();
}

class _NewUserDialogState extends State<NewUserDialog> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
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

  addErrorMessageIfNeeded(List<Widget> children, RegisterType registerAttempt) {
    TextStyle errorStyle = const TextStyle(color: Colors.red);
    if (registerAttempt == RegisterType.passwordFail) {
      children.add(Text("Passwords do not match", style: errorStyle,));
    } else if (registerAttempt == RegisterType.userExists) {
      children.add(Text("User already exists", style: errorStyle,));
    }
  }

  // TODO: Study polymorphism further to change buildRegistrationChildren to a class
  Widget buildRegistrationChildren(BuildContext context, RegisterType registerAttempt) {

    List<Widget> children = [
      UsernameTextField(textEditingController: _usernameController),
      PasswordTextField(textEditingController: _passwordController, hintText: "Password"),
      PasswordTextField(textEditingController: _confirmPasswordController, hintText: "Confirm Password"),
      DialogBottomRow(cancel: cancel, submit: submit)
    ];
    addErrorMessageIfNeeded(children, registerAttempt);

    return Column(mainAxisSize: MainAxisSize.min, children: children);
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
