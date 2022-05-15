import 'bloc_event.dart';

class RegisterAccount extends BlocEvent {
  final String username;
  final String password;
  RegisterAccount(this.username, this.password);
}