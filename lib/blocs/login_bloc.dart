import 'package:example_cpl/database/db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'do_login.dart';

enum LoginType {succeeded, passwordFail, usernameFail, unknown}
enum RegisterType {succeeded, userExists, passwordFail}

class LoginBloc extends Bloc<BlocEvent, LoginType> {
  LoginBloc() : super(LoginType.unknown) {
    // make all of the events here
    on<DoLogin>((event, emit) {
      print("running");
      DatabaseProvider provider = DatabaseProvider();
      provider.checkLogin(username: event.username, password: event.password);
    });
  }
}