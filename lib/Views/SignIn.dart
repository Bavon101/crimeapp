import 'dart:developer';

import 'package:crimeapp/Contollers/FireGoogleService.dart';
import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../main.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoading = false;
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Sign In to proceed.',style: TextStyle(
                fontSize: WIDTH(context: context)*.05
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton.icon(
                  onPressed:!isLoading ?() async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await service.signInwithGoogle();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/home', (route) => false);
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        showToast(message: e.message!);
                        log(e.message!);
                      }
                    }
                    setState(() {
                      isLoading = false;
                    });
                  }:null,
                  icon: CircleAvatar(
                    backgroundColor: Colors.white,
                  backgroundImage: AssetImage('assets/images/google480.png'),
                  ),
                  label:!isLoading ? Text('Sign In with Google'):CircularProgressIndicator()),
            )
          ],
        ),
      ),
    );
  }
}
