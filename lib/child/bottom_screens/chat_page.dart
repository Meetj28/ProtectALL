
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/child/login_page.dart';
import 'package:women_safety_app/utils/constants.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: () async {
          try {
            await FirebaseAuth.instance.signOut();
            goTo(context, LoginScreen());
          } on FirebaseAuthException catch(e) {
            dialogueBox(context, e.toString());
          }
        }, child: Text(
          "Sign Out",
        ),),
      ),
    );
  }
}
