import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({Key? key}) : super(key: key);

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  bool isLoginPage = false;
  var _username = "";

  startAuthentication() {
    final validity = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (validity) {
      _formKey.currentState!.save();
      createAUser(_email, _password, _username);
    }
  }

  createAUser(String email, String password, String username) async {
    if (!isLoginPage) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        String userId = credential.user!.uid;
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({'userName': username, 'email': email});
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          // print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          // print('The account already exists for that email.');
        }
      } catch (e) {
        // print(e);
      }
    } else {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          // print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          // print('Wrong password provided for that user.');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    !isLoginPage
                        ? TextFormField(
                            validator: (value) {
                              if (value!.isEmpty || value.length < 6) {
                                return 'Incorrect Username';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              _username = value!;
                            },
                            keyboardType: TextInputType.name,
                            key: const ValueKey('username'),
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    borderSide: const BorderSide()),
                                labelText: "Enter Username",
                                labelStyle: GoogleFonts.roboto()),
                          )
                        : Container(),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || !value.contains('@')) {
                          return 'Invalid Email';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _email = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      key: const ValueKey('email'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: "Enter Email",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Incorrect Password ';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _password = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      obscureText: true,
                      key: const ValueKey('password'),
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide()),
                          labelText: "Enter Password",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            backgroundColor: Theme.of(context).primaryColor,
                            padding: const EdgeInsets.all(12)),
                        onPressed: () {
                          startAuthentication();
                        },
                        child: isLoginPage
                            ? Text(
                                "Login",
                                style: GoogleFonts.roboto(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              )
                            : Text(
                                "Sign Up",
                                style: GoogleFonts.roboto(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            isLoginPage = !isLoginPage;
                          });
                        },
                        child: isLoginPage
                            ? Text(
                                "Not a member? Sign Up",
                                style: GoogleFonts.roboto(
                                    fontSize: 14, color: Colors.white),
                              )
                            : Text(
                                "Already a Member? Log In",
                                style: GoogleFonts.roboto(
                                    fontSize: 14, color: Colors.white),
                              ))
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
