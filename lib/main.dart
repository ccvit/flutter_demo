import 'dart:async';

import 'package:example_cpl/blocs/do_login.dart';
import 'package:example_cpl/database/db.dart';
import 'package:example_cpl/widgets/login_button.dart';
import 'package:example_cpl/widgets/password_text_field.dart';
import 'package:example_cpl/widgets/register_message.dart';
import 'package:example_cpl/widgets/username_text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/login_bloc.dart';
import 'dialogs/new_user_dialog.dart';
import 'planet_database_screen.dart';

void main() {
  // initialize database
  DatabaseProvider provider = DatabaseProvider();
  provider.initDb();

  runApp(const FlutterDemo());
}

class FlutterDemo extends StatelessWidget {
  const FlutterDemo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'My Demo App!'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final LoginBloc _loginBloc = LoginBloc();

  //stream variables
  final StreamController<LoginType> _loginTypeController = StreamController<LoginType>();
  late StreamSubscription<LoginType> _loginSubscription;

  void doLogin(BuildContext context) async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;
    DoLogin login = DoLogin(username, password, _loginTypeController);
    _loginBloc.add(login);
  }

  void buildErrorMessageIfNeeded(List<Widget> loginChildren, LoginType loginAttempt) {
    if (loginAttempt != LoginType.succeeded) {
      if (loginAttempt == LoginType.passwordFail) {
        loginChildren.add(const Text("Incorrect Password", style: TextStyle(color: Colors.red)));
      } else if (loginAttempt == LoginType.usernameFail){
        loginChildren.add(const Text("User not found", style: TextStyle(color: Colors.red)));
      }
    }
  }

  Widget buildLoginChildren(BuildContext context, LoginType loginAttempt) {
    List<Widget> loginChildren = [
      UsernameTextField(textEditingController: _usernameController),
      PasswordTextField(textEditingController: _passwordController, hintText: "Password"),
      LoginButton(onPressAction: doLogin,),
      const RegisterMessage()
    ];
    buildErrorMessageIfNeeded(loginChildren, loginAttempt);

    return Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: loginChildren,
          ),
        ));
  }

  @override
  void initState() {
    _loginSubscription = _loginTypeController.stream.listen((event) {
      if (event == LoginType.succeeded) {
        Navigator.of(context).push(PlanetDatabase.route());
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocBuilder<LoginBloc, LoginType>(
        bloc: _loginBloc,
        builder: buildLoginChildren,
      )
    );
  }

  @override 
  void dispose() {
    _loginBloc.close();
    _loginSubscription.cancel();
    _loginTypeController.close();
    super.dispose();
  }
}