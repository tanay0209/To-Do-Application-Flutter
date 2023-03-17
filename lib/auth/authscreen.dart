import 'package:flutter/material.dart';
import 'package:todo_flutter/auth/authform.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("To Do Application"),
        centerTitle: true,
      ),
      body: const AuthForm(),
    );
  }
}
