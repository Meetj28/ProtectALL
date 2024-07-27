

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/child/login_page.dart';
import 'package:women_safety_app/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserID;
  final String friendID;
  final String friendName;

  const ChatScreen({super.key,
  required this.currentUserID, required this.friendID, required this.friendName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.grey,
       title: Text(widget.friendName),
     ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users')
          .doc(widget.currentUserID)
          .collection('messages')
          .doc(widget.friendID),
        initialData:  initialData,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: child
          )
        }
      )
    );
  }
}
