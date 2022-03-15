import 'package:example_cpl/database/db.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'dialogs/new_user_dialog.dart';
import 'hub_screen.dart';
import 'util.dart';

void main() {
  DatabaseProvider provider = DatabaseProvider();
  provider.initDb();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  final TextStyle linkStyle = const TextStyle(
      color: Colors.blue,
      decoration: TextDecoration.underline
  );
  final TextStyle normalStyle = const TextStyle(color: Colors.grey);
  LoginType? loginAttempt;
  void doLogin(BuildContext context) async {
    String username = _usernameController.value.text;
    String password = _passwordController.value.text;

    if (username.trim() != "" && password.trim() != ""){
      DatabaseProvider provider = DatabaseProvider();
      loginAttempt = await provider.checkLogin(username: username, password: password);
      if (loginAttempt == LoginType.succeeded) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Hub(username)),
        );
      }
      setState((){});
    }
  }

  void signUpDialog(BuildContext context) {
    setState((){
      loginAttempt = LoginType.succeeded;
      showDialog(
          context: context,
          builder: (context) {
            return const NewUser();
          });
    });
  }

  @override
  Widget build(BuildContext context) {

    // Base children. Will always show.
    List<Widget> loginChildren = [
      buildTextField(
          obscureText: false,
          hint: "Username",
          textEditingController: _usernameController
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: buildTextField(
            obscureText: true,
            hint: "Password",
            textEditingController: _passwordController
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Center(child: ElevatedButton(onPressed: (){doLogin(context);}, child: const Text("Login"))),
      ),
      RichText(
          text: TextSpan(
              style: normalStyle,
              children: [
                const TextSpan(text: "New user? "),
                TextSpan(
                    text: "Sign up",
                    style: linkStyle,
                    recognizer: TapGestureRecognizer()..onTap = () => signUpDialog(context)
                ),
                const TextSpan(text: " today!")
              ]
          )
      )
    ];

    // messages
    if (loginAttempt != LoginType.succeeded) {
      if (loginAttempt == LoginType.passwordFail) {
        loginChildren.add(const Text("Incorrect password", style: errorStyle,));
      } else if (loginAttempt == LoginType.usernameFail) {
        loginChildren.add(const Text("User not found", style: errorStyle));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width / 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: loginChildren,
          ),
        ),
      )
    );
  }
}