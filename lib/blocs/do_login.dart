import 'bloc_event.dart';

class DoLogin extends BlocEvent {
  final String username;
  final String password;

  DoLogin(this.username, this.password);
}