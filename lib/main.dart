import 'dart:async';

import 'package:example_cpl/blocs/do_login.dart';
import 'package:example_cpl/database/db.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/login_bloc.dart';
import 'dialogs/new_user_dialog.dart';
import 'planet_database_screen.dart';
import 'util.dart';

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

  // themes
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline
  );
  final TextStyle normalStyle = const TextStyle(color: Colors.grey);

  // BLoC
  final LoginBloc _loginBloc = LoginBloc();

  //stream variables
  // not using BlocListener. sometimes the login is not the same.
  final StreamController<LoginType> _loginTypeController = StreamController<LoginType>();
  late StreamSubscription<LoginType> _loginSubscription;

  void doLogin(BuildContext context) async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;
    DoLogin login = DoLogin(username, password, _loginTypeController);
    _loginBloc.add(login);
  }

  void signUpDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const NewUserDialog();
        }
    );
  }

  Widget buildRegisterMessage() {
    TapGestureRecognizer signUpClicked = TapGestureRecognizer();
    signUpClicked.onTap = () => signUpDialog(context);

    return RichText(
        text: TextSpan(
            style: normalStyle,
            children: [
              const TextSpan(text: "New user? "),
              TextSpan(text: "Sign up", style: linkStyle, recognizer: signUpClicked),
              const TextSpan(text: " today!")
            ]
        )
    );
  }

  void buildErrorMessageIfNeeded(List<Widget> loginChildren, LoginType loginAttempt) {
    if (loginAttempt != LoginType.succeeded) {
      if (loginAttempt == LoginType.passwordFail) {
        loginChildren.add(const Text("Incorrect Password", style: errorStyle));
      } else if (loginAttempt == LoginType.usernameFail){
        loginChildren.add(const Text("User not found", style: errorStyle));
      }
    }
  }

  Widget buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Center(
        child: ElevatedButton(
            onPressed: (){
              doLogin(context);
            },
            child: const Text("Login")
        )
      ),
    );
  }

  Widget buildPasswordTextBox() {
    return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: buildTextField(
          obscureText: true,
          hint: "Password",
          textEditingController: _passwordController
      )
    );
  }

  Widget buildLoginChildren(BuildContext context, LoginType loginAttempt) {
    // Base children. Will always show.
    List<Widget> loginChildren = [
      buildTextField(hint: "Username", textEditingController: _usernameController, obscureText: false),
      buildPasswordTextBox(),
      buildLoginButton(),
      buildRegisterMessage()
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