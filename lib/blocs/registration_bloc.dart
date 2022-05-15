import 'package:example_cpl/database/db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'do_registration.dart';

enum RegisterType {succeeded, userExists, passwordFail, unknown}

class RegisterBloc extends Bloc<BlocEvent, RegisterType> {
  RegisterBloc() : super(RegisterType.unknown) {
    on<DoRegistration>((event, emit) async {
      String username = event.username;
      String password = event.password;
      String confirmPassword = event.confirmPassword;
      RegisterType registerType;

      if (password == confirmPassword) {
        DatabaseProvider provider = DatabaseProvider();

        registerType = await provider.createUser(
            username: username,
            password: password
        );

      } else {
        registerType = RegisterType.passwordFail;
      }

      emit(registerType);
    });
  }
}