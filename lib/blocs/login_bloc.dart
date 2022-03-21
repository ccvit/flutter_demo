import 'package:example_cpl/database/db.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc_event.dart';
import 'do_login.dart';

enum LoginType {succeeded, passwordFail, usernameFail, unknown}
enum RegisterType {succeeded, userExists, passwordFail}

class NewBloc extends Bloc<BlocEvent, Map<String, dynamic>> {
  NewBloc() : super({}) {
    // make all of the events here
    on<DoLogin>((event, emit) {
      DatabaseProvider provider = DatabaseProvider();
      provider.checkLogin(username: event.username, password: event.password);
    });
  }
}