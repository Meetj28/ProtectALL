import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/database/shared_pref.dart';
import 'package:women_safety_app/home_screen.dart';
import 'package:women_safety_app/login_page.dart';
import 'package:women_safety_app/parent/parent_home.dart';
import 'package:women_safety_app/parent/register_parent.dart';
import 'package:women_safety_app/register_child.dart';
import 'package:women_safety_app/utils/constants.dart';
// import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  MySharedPreference.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        // useMaterial3: true,
        // textTheme: GoogleFonts.firaSansTextTheme(),
        // Theme.of(context),textTheme,
      ),
      home: MySharedPreference.getUserType() == "child"
        ? HomeScreen()
          : MySharedPreference.getUserType() == "parent"
        ? ParentHomeScreen()
          : LoginScreen()
      // FutureBuilder(
      //   future: MySharedPreference.getUserType(),
      //   builder: (BuildContext context, AsyncSnapshot snapshot) {
      //     if (snapshot.data == "") {
      //       return LoginScreen();
      //     }
      //     if (snapshot.data == "child") {
      //       return HomeScreen();
      //     }
      //     if (snapshot.data == "parent") {
      //       return ParentHomeScreen();
      //     }
      //     return progressIndicator(context);
      //   },
      // ),
    );
   }
 }

// class CheckAuth extends StatelessWidget {
//   // const CheckAuth({super.key});
//   checkData(){
//     if(MySharedPreference.getUserType()=='parent'){
//
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }

