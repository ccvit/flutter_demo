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
      home: BlocProvider<LoginBloc>(
        create: (_) => LoginBloc(),
        child:  const MyHomePage(title: 'My Demo App!'),
      ),
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
  LoginType? loginAttempt;

  void doLogin(BuildContext context) async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;
    if (username.trim() != "" && password.trim() != "") {
      DoLogin login = DoLogin(username, password);
      context.read<LoginBloc>().add(login);
      // DatabaseProvider provider = DatabaseProvider();
      // loginAttempt = await provider.checkLogin(username: username, password: password);
      // if (loginAttempt == LoginType.succeeded) {
      //   Navigator.push(
      //     context,
      //     MaterialPageRoute(builder: (context) => PlanetDatabase(username)),
      //   );
      // }
      // setState((){});
    }
  }

  void signUpDialog(BuildContext context) {
    setState((){
      loginAttempt = LoginType.succeeded;
      showDialog(
          context: context,
          builder: (context) {
            return const NewUserDialog();
          }
      );
    });
  }

  List<Widget> buildLoginChildren() {
    List<Widget> loginChildren = [];
    loginChildren.add(buildTextField(obscureText: false, hint: "Username", textEditingController: _usernameController));
    return loginChildren;

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
            textEditingController: _passwordController)
    );
  }

  blocListener(BuildContext context, dynamic loginType) {
    print("listener firing $loginType");
  }

  @override
  Widget build(BuildContext context) {

    // Base children. Will always show.
    List<Widget> loginChildren = [
      buildTextField(hint: "Username", textEditingController: _usernameController, obscureText: false),
      buildPasswordTextBox(),
      buildLoginButton(),
      buildRegisterMessage()
    ];
    buildErrorMessageIfNeeded(loginChildren);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: BlocListener<LoginBloc, LoginType>(
        bloc: LoginBloc(),
        listener: blocListener,
        child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: loginChildren,
              ),
            )),
      )
    );
  }

  @override 
  void dispose() {
    //_authenticationBloc.dispose();
    super.dispose();
  }
}