import 'package:example_cpl/database/db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'do_login.dart';

enum LoginType {succeeded, passwordFail, usernameFail, unknown}

class LoginBloc extends Bloc<BlocEvent, LoginType> {
  LoginBloc() : super(LoginType.unknown) {
    on<DoLogin>((event, emit) async {
      DatabaseProvider provider = DatabaseProvider();
      LoginType loginType = await provider.checkLogin(
          username: event.username,
          password: event.password
      );

      event.loginTypeController.add(loginType);
      emit(loginType);
    });
  }
}