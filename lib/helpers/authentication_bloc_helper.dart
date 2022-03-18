import 'package:flutter/cupertino.dart';

class AuthenticationBlocHelper {
  final TextEditingController _usernameController;
  final TextEditingController _passwordController;
  final StateSetter setState;
  final BuildContext context;

  AuthenticationBlocHelper(this._usernameController, this._passwordController, this.setState, this.context);
}