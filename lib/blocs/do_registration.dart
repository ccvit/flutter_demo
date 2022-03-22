import 'bloc_event.dart';

class DoRegistration extends BlocEvent {
  final String username;
  final String password;
  final String confirmPassword;
  DoRegistration(this.username, this.password, this.confirmPassword);
}