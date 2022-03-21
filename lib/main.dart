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

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const FlutterDemo());
  }

  // Nav keys
  static final navigatorKey = GlobalKey<NavigatorState>();
  static NavigatorState get navigator => navigatorKey.currentState!;


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
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
  //final AuthenticationBloc _authenticationBloc = AuthenticationBloc();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline
  );
  final TextStyle normalStyle = const TextStyle(color: Colors.grey);
  final LoginBloc _loginBloc = LoginBloc();
  LoginType? _loginAttempt;

  void doLogin(BuildContext context) async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;
    DoLogin login = DoLogin(username, password);
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

  void buildErrorMessageIfNeeded(List<Widget> loginChildren) {
    if (_loginAttempt != LoginType.succeeded) {
      if (_loginAttempt == LoginType.passwordFail) {
        loginChildren.add(const Text("Incorrect Password", style: errorStyle));
      } else if (_loginAttempt == LoginType.usernameFail){
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

  checkLogin(BuildContext context, LoginType loginAttempt) {
    _loginAttempt = loginAttempt;
    if (loginAttempt == LoginType.succeeded) {
      FlutterDemo.navigator.pushAndRemoveUntil<void>(
        PlanetDatabase.route(),
            (route) => false,
      );
    }
  }

  Widget buildLoginChildren(BuildContext context, LoginType loginAttempt) {
    // Base children. Will always show.
    List<Widget> loginChildren = [
      buildTextField(hint: "Username", textEditingController: _usernameController, obscureText: false),
      buildPasswordTextBox(),
      buildLoginButton(),
      buildRegisterMessage()
    ];
    buildErrorMessageIfNeeded(loginChildren);

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<LoginBloc, LoginType>(
        bloc: _loginBloc,
        listener: checkLogin,
        child: BlocBuilder<LoginBloc, LoginType>(
          bloc: _loginBloc,
          builder: buildLoginChildren,
        ),
      )
    );
  }

  @override 
  void dispose() {
    _loginBloc.dispose();
    super.dispose();
  }
}