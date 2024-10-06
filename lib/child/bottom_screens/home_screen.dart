import 'dart:math';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_safety_app/widgets/home_widgets/CustomCarouel.dart';
import 'package:women_safety_app/widgets/home_widgets/SafeHome/Safehome.dart';
import 'package:women_safety_app/widgets/home_widgets/custom_appBar.dart';
import 'package:women_safety_app/widgets/home_widgets/emergency.dart';
import 'package:women_safety_app/widgets/livesafe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // const HomeScreen({super.key});
  int qIndex = 0;

  Position? _currentPosition;
  String? _currentAddress;
  LocationPermission? permission;

  _getPermission() async => await [Permission.sms].request;
  _isPermissionGranted() async => await Permission.sms.status.isGranted;
  _sendSms(String phoneNumber, String message, {int? simSlot}) async{
    await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot,
    ).then((SmsStatus status){
      if(status == 'sent'){
        Fluttertoast.showToast(msg:"sent");
      }
      else{
        Fluttertoast.showToast(msg:"failed");
      }
    });
  }

  _getCurrentLocation() async {
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions denied");
      if (permission == LocationPermission.deniedForever) {
        Fluttertoast.showToast(msg: "Location permissions denied permanently");
      }
    }
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true
    ).then((Position position) {
      setState(() {
        _currentPosition = position;
        _getAddressFromLatiLongi();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatiLongi() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude);
      Placemark place = placemarks[0];
      setState(() {
        _currentAddress = "${place.locality},${place.postalCode},${place.street},";
      });
    } catch(e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(5);
    });
  }

  @override
  void initState() {
    getRandomQuote();
    super.initState();
    _getPermission();
    _getCurrentLocation();

    // ShakeDetector detector = ShakeDetector.autoStart(
    //   onPhoneShake: () {
    //     ScaffoldMessenger.of(context).showSnackBar(
    //       const SnackBar(
    //         content: Text('Shake!'),
    //       ),
    //     );
    //     // Do stuff on phone shake
    //   },
    //   minimumShakeCount: 3,
    //   shakeSlopTimeMS: 500,
    //   shakeCountResetTime: 3000,
    //   shakeThresholdGravity: 2.7,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomAppBar(
                quoteIndex: qIndex,
                onTap: () {
                   getRandomQuote();
                }),
             Expanded(
               child: ListView(
                 shrinkWrap: true,
                 children: [
                   CustomCarouel(),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Emergency",
                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                   ),
                   Emergency(),
                   Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text("Explore LiveSafe",
                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                   ),
                   LiveSafe(),
                   SafeHome(),
                 ],
               )
             )

               ],
             ),
        ),
      ),
    );
  }
}
