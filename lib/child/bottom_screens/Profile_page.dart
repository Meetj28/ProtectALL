import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:women_safety_app/child/bottom_bar.dart';
// import 'package:women_safety_app/child/bottom_page.dart';
// import 'package:women_safety_app/child/child_login_screen.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';
import 'package:women_safety_app/components/custom_textfield.dart';
import 'package:women_safety_app/utils/constants.dart';

import '../login_page.dart';

class CheckUserStatusBeforeChatOnProfile extends StatelessWidget {
  const CheckUserStatusBeforeChatOnProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else {
          if (snapshot.hasData) {
            return ProfilePage();
          } else {
            Fluttertoast.showToast(msg: 'please login first');
            return LoginScreen();
          }
        }
      },
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameC = TextEditingController();
  TextEditingController guardianEmailC = TextEditingController();
  TextEditingController childEmailC = TextEditingController();
  TextEditingController phoneC = TextEditingController();

  final key = GlobalKey<FormState>();
  String? id;
  String? profilePic;
  String? downloadUrl;
  bool isSaving = false;
  getDate() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('id', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameC.text = value.docs.first['name'];
        childEmailC.text = value.docs.first['childEmail'];
        guardianEmailC.text = value.docs.first['parentEmail'];
        phoneC.text = value.docs.first['phone'];
        id = value.docs.first.id;
        profilePic = value.docs.first['profilePic'];
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: isSaving == true
          ? Center(
          child: CircularProgressIndicator(
            backgroundColor: Colors.pink,
          ))
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Center(
            child: Form(
                key: key,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      "UPDATE YOUR PROFILE",
                      style: TextStyle(fontSize: 25),
                    ),
                    SizedBox(height: 15),
                    GestureDetector(
                      onTap: () async {
                        final XFile? pickImage = await ImagePicker()
                            .pickImage(
                            source: ImageSource.gallery,
                            imageQuality: 50);
                        if (pickImage != null) {
                          setState(() {
                            profilePic = pickImage.path;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(100)
                              
                        ),
                        child: profilePic == null
                            ? CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 80,

                          child: Center(
                              child: Image.asset(
                                'assets/2246807_instagram_person_profile_user_icon.png',
                                height: 80,
                                width: 80,
                              )),
                        )
                            : profilePic!.contains('http')
                            ? CircleAvatar(
                          backgroundColor: Colors.grey,
                          radius: 80,
                          backgroundImage:
                          NetworkImage(profilePic!),
                        )
                            : CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            radius: 80,
                            backgroundImage:
                            FileImage(File(profilePic!))),
                      ),
                    ),
                    CustomTextfield(
                      controller: nameC,
                      hintText: nameC.text,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return 'please enter your updated name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      controller: childEmailC,
                      hintText: "child email",
                      readOnly: true,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return 'please enter your updated name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      controller: guardianEmailC,
                      hintText: "parent email",
                      readOnly: true,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return 'please enter your updated name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    CustomTextfield(
                      controller: phoneC,
                      hintText: "Phone number",
                      readOnly: true,
                      validate: (v) {
                        if (v!.isEmpty) {
                          return 'please enter your updated name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 25),
                    Primarybutton(
                        title: "UPDATE",
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            SystemChannels.textInput
                                .invokeMethod('TextInput.hide');
                            profilePic == null
                                ? Fluttertoast.showToast(
                                msg: 'please select profile picture')
                                : update();
                          }
                        })
                  ],
                )),
          ),
        ),
      ),
    );
  }

  Future<String?> uploadImage(String filePath) async {
    try {
      final filenName = Uuid().v4();
      final Reference fbStorage =
      FirebaseStorage.instance.ref('profile').child(filenName);
      final UploadTask uploadTask = fbStorage.putFile(File(filePath));
      await uploadTask.then((p0) async {
        downloadUrl = await fbStorage.getDownloadURL();
      });
      return downloadUrl;
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  update() async {
    setState(() {
      isSaving = true;
    });
    uploadImage(profilePic!).then((value) {
      Map<String, dynamic> data = {
        'name': nameC.text,
        'profilePic': downloadUrl,  // Add the image download URL to the user's Firestore document
      };
      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update(data);  // Update the user document in Firestore
      setState(() {
        isSaving = false;
        goTo(context, BottomBar());  // Redirect after update
      });
    });
  }


// update() async {
  //   setState(() {
  //     isSaving = true;
  //   });
  //   uploadImage(profilePic!).then((value) {
  //     Map<String, dynamic> data = {
  //       'name': nameC.text,
  //       'profilePic': downloadUrl,
  //     };
  //     FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser!.uid)
  //         .update(data);
  //     setState(() {
  //       isSaving = false;
  //       goTo(context, BottomBar());
  //     });
  //   });
  // }
}