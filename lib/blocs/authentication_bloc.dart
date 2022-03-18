//
// import 'dart:async';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
//
// import '../database/db.dart';
// import '../hub_screen.dart';
// import '../util.dart';
//
// enum AuthenticationEvent {
//   authenticate
// }
// class AuthenticationBloc {
//   AuthenticationBloc() {
//     eventStream.listen((AuthenticationEvent event) {
//
//       if(event == AuthenticationEvent.authenticate){
//         doLogin(context);
//       }
//
//     });
//   }
//
//   final _eventController = StreamController<AuthenticationEvent>();
//   Stream<AuthenticationEvent> get eventStream => _eventController.stream;
//   Sink<AuthenticationEvent> get eventSink => _eventController.sink;
//
//   void doLogin(BuildContext context) async {
//     String username = _usernameController.value.text;
//     String password = _passwordController.value.text;
//
//     if (username.trim() != "" && password.trim() != ""){
//       DatabaseProvider provider = DatabaseProvider();
//       LoginType loginAttempt = await provider.checkLogin(username: username, password: password);
//       eventSink.add(loginAttempt);
//       if (loginAttempt == LoginType.succeeded) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => Hub(username)),
//         );
//       }
//       setState((){});
//     }
//   }
//
//   void dispose() {
//     _eventController.close();
//   }
// }