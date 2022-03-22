import 'dart:async';

import 'bloc_event.dart';
import 'login_bloc.dart';

class DoLogin extends BlocEvent {
  final String username;
  final String password;
  final StreamController<LoginType> loginTypeController;
  DoLogin(this.username, this.password, this.loginTypeController);
}