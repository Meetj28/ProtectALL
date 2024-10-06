// import 'dart:js_interop';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/chat_section/message_field.dart';
import 'package:women_safety_app/chat_section/singlemessage.dart';
import 'package:women_safety_app/child/login_page.dart';
import 'package:women_safety_app/utils/constants.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserID;
  final String friendID;
  final String friendName;

  const ChatScreen(
      {super.key,
      required this.currentUserID,
      required this.friendID,
      required this.friendName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String? type;
  String? myName;

  getStatus() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.currentUserID)
        .get()
        .then((value) {
      setState(() {
        type = value.data()!['type'];
        myName = value.data()!['name'];
      });
    });
  }

  @override
  void iniState() {
    getStatus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          title: Text(widget.friendName),
        ),
        body: Column(children: [
          Expanded(
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.currentUserID)
                    .collection('messages')
                    .doc(widget.friendID)
                    .collection('chats')
                    .orderBy('date', descending: false)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.length < 1) {
                      return Center(
                        child: Text(
                          type == 'parent'
                              ? "Talk with child"
                              : "Talk with parent",
                          style: TextStyle(fontSize: 30),
                        ),
                      );
                    }
                    return Container(
                      child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (BuildContext context, int index) {
                          bool isMe = snapshot.data!.docs[index]['senderId'] ==
                              widget.currentUserID;
                          final data = snapshot.data!.docs[index];
                          return Dismissible(
                            key: UniqueKey(),
                            onDismissed: (direction) async {
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.currentUserID)
                                  .collection('messages')
                                  .doc(widget.friendID)
                                  .collection('chats')
                                  .doc(data.id)
                                  .delete();
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(widget.friendID)
                                  .collection('messages')
                                  .doc(widget.currentUserID)
                                  .collection('chats')
                                  .doc(data.id)
                                  .delete()
                                  .then((value) => Fluttertoast.showToast(
                                      msg: 'message deleted successfully'));
                            },
                            child: SingleMessage(
                              message: data['message'],
                              date: data['date'],
                              isMe: isMe,
                              friendName: widget.friendName,
                              myName: myName,
                              type: data['type'],
                            ),
                          );
                        },
                      ),
                    );
                  }
                  return progressIndicator(context);
                },
            ),
          ),
          MessageTextField(
            currentID: widget.currentUserID,
            friendID: widget.friendID,
          ),
        ]));
  }
}
