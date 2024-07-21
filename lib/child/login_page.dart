import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/components/custom_textfield.dart';
import 'package:women_safety_app/components/primarybutton.dart';
import 'package:women_safety_app/components/secondarybutton.dart';
import 'package:women_safety_app/database/shared_pref.dart';
import 'package:women_safety_app/child/bottom_screens/home_screen.dart';
import 'package:women_safety_app/parent/parent_home.dart';
import 'package:women_safety_app/parent/register_parent.dart';
import 'package:women_safety_app/child/register_child.dart';
import 'package:women_safety_app/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isPasswordShown = true;
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  _onSubmit() async {
    _formKey.currentState!.save();
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: _formData['email'].toString(),
          password: _formData['password'].toString());
      if (userCredential.user != null) {
        setState(() {
          isLoading = true;
        });
        FirebaseFirestore.instance
        .collection('users')
        .doc(userCredential.user!.uid)
        .get()
        .then((value) {
          if (value['type']=='parent') {
            print(value['type']);
            MySharedPreference.saveUserType('parent');
            goTo(context, ParentHomeScreen());
          }
          else {
            MySharedPreference.saveUserType('child');
            goTo(context, HomeScreen());
          }
        });

      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        dialogueBox(context, "No user found for that email");
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        dialogueBox(context, "Wrong password provided for that user");
        print('The account already exists');
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              isLoading
                  ? progressIndicator(context)
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "USER LOGIN",
                                  style: TextStyle(
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                      color: kColorRed),
                                ),
                                Image.asset(
                                  'assets/2246807_instagram_person_profile_user_icon.png',
                                  height: 100,
                                  width: 100,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.4,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CustomTextfield(
                                    hintText: 'enter email',
                                    textInputAction: TextInputAction.next,
                                    keyboardtype: TextInputType.emailAddress,
                                    prefix: Icon(Icons.person),
                                    onsave: (email) {
                                      _formData['email'] = email ?? "";
                                    },
                                    validate: (email) {
                                      if (email!.isEmpty ||
                                          email.length < 3 ||
                                          !email.contains("@")) {
                                        return 'enter correct email';
                                      }
                                    },
                                  ),
                                  CustomTextfield(
                                    hintText: 'enter password',
                                    isPassword: isPasswordShown,
                                    prefix: Icon(Icons.vpn_key_rounded),
                                    validate: (password) {
                                      if (password!.isEmpty ||
                                          password.length < 7) {
                                        return 'enter correct password';
                                      }
                                      return null;
                                    },
                                    onsave: (password) {
                                      _formData['password'] = password ?? "";
                                    },
                                    suffix: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isPasswordShown = !isPasswordShown;
                                          });
                                        },
                                        icon: isPasswordShown
                                            ? Icon(Icons.visibility_off)
                                            : Icon(Icons.visibility)),
                                  ),
                                  Primarybutton(
                                      title: 'LOGIN',
                                      onPressed: () {
// progressIndicator(context);
                                        if (_formKey.currentState!.validate()) {
                                          _onSubmit();
                                        }
                                      }),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Forgot Password?",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SecondaryButton(
                                    title: 'click here', onPressed: () {}),
                              ],
                            ),
                          ),
                          SecondaryButton(
                              title: 'Register as child',
                              onPressed: () {
                                goTo(context, RegisterChildScreen());
                              }),
                          SecondaryButton(
                              title: 'Register as Parent',
                              onPressed: () {
                                goTo(context, RegisterParentScreen());
                              }),
                        ],
                      ),
                    ),
            ],
          ),
        )),
      );
    }
  }

