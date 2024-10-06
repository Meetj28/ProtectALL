// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/child/login_page.dart';
import 'package:women_safety_app/model/userModel.dart';
import 'package:women_safety_app/utils/constants.dart';
import '../components/PrimaryButton.dart';
import '../components/SecondaryButton.dart';
import '../components/custom_textfield.dart';
// import '../model/user_model.dart';

class RegisterParentScreen extends StatefulWidget {
  @override
  State<RegisterParentScreen> createState() => _RegisterParentScreenState();
}

class _RegisterParentScreenState extends State<RegisterParentScreen> {
  bool isPasswordShown = true;
  bool isRetypePasswordShown = true;

  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();
  bool isLoading = false;

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_formData['password'] != _formData['rpassword']) {
        dialogueBox(context, 'Password and retype password should be equal');
      } else {
        setState(() {
          isLoading = true;
        });
        try {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
            email: _formData['email'].toString(),
            password: _formData['password'].toString(),
          );
          if (userCredential.user != null) {
            final userId = userCredential.user!.uid;
            DocumentReference<Map<String, dynamic>> db =
            FirebaseFirestore.instance.collection('users').doc(userId);

            final user = UserModel(
              name: _formData['name'].toString(),
              phone: _formData['phone'].toString(),
              childEmail: _formData['email'].toString(),
              parentEmail: _formData['gemail'].toString(),
              id: userId,
              type: 'parent',
            );
            final jsonData = user.toJson();
            await db.set(jsonData).whenComplete(() {
              goTo(context, LoginScreen());
              setState(() {
                isLoading = false;
              });
            });
          }
        } on FirebaseAuthException catch (e) {
          setState(() {
            isLoading = false;
          });
          if (e.code == 'weak-password') {
            dialogueBox(context, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            dialogueBox(context, 'The account already exists for that email.');
          }
        } catch (e) {
          setState(() {
            isLoading = false;
          });
          dialogueBox(context, e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Stack(
            children: [
              isLoading ?
              progressIndicator(context)
                  : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "REGISTER AS PARENT",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Image.asset(
                            'assets/2246807_instagram_person_profile_user_icon.png',
                            height: 100,
                            width: 100,
                          ),
                        ],
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomTextfield(
                            hintText: 'enter name',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.name,
                            prefix: Icon(Icons.person),
                            onsave: (name) {
                              _formData['name'] = name ?? "";
                            },
                            validate: (email) {
                              if (email!.isEmpty || email.length < 3) {
                                return 'enter correct name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextfield(
                            hintText: 'enter phone',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.phone,
                            prefix: Icon(Icons.phone),
                            onsave: (phone) {
                              _formData['phone'] = phone ?? "";
                            },
                            validate: (email) {
                              if (email!.isEmpty || email.length < 10) {
                                return 'enter correct phone';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextfield(
                            hintText: 'enter parent email',
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
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextfield(
                            hintText: 'enter child email',
                            textInputAction: TextInputAction.next,
                            keyboardtype: TextInputType.emailAddress,
                            prefix: Icon(Icons.person),
                            onsave: (gemail) {
                              _formData['gemail'] = gemail ?? "";
                            },
                            validate: (email) {
                              if (email!.isEmpty ||
                                  email.length < 3 ||
                                  !email.contains("@")) {
                                return 'enter correct email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          CustomTextfield(
                            hintText: 'enter password',
                            isPassword: isPasswordShown,
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty || password.length < 7) {
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
                                  : Icon(Icons.visibility),
                            ),
                          ),
                          SizedBox(height: 10),
                          CustomTextfield(
                            hintText: 'retype password',
                            isPassword: isRetypePasswordShown,
                            prefix: Icon(Icons.vpn_key_rounded),
                            validate: (password) {
                              if (password!.isEmpty || password.length < 7) {
                                return 'enter correct password';
                              }
                              return null;
                            },
                            onsave: (password) {
                              _formData['rpassword'] = password ?? "";
                            },
                            suffix: IconButton(
                              onPressed: () {
                                setState(() {
                                  isRetypePasswordShown = !isRetypePasswordShown;
                                });
                              },
                              icon: isRetypePasswordShown
                                  ? Icon(Icons.visibility_off)
                                  : Icon(Icons.visibility),
                            ),
                          ),
                          SizedBox(height: 20),
                          Primarybutton(
                            title: 'REGISTER',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _onSubmit();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    SecondaryButton(
                      title: 'Login with your account',
                      onPressed: () {
                        goTo(context, LoginScreen());
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}