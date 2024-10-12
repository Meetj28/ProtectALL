// import 'dart:math';
// import 'package:background_sms/background_sms.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shake/shake.dart';
// import 'package:women_safety_app/widgets/home_widgets/CustomCarouel.dart';
// import 'package:women_safety_app/widgets/home_widgets/SafeHome/Safehome.dart';
// import 'package:women_safety_app/widgets/home_widgets/custom_appBar.dart';
// import 'package:women_safety_app/widgets/home_widgets/emergency.dart';
// import 'package:women_safety_app/widgets/livesafe.dart';
//
// import '../../database/datab_services.dart';
// import '../../model/contact_model.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   // const HomeScreen({super.key});
//   int qIndex = 0;
//
//   Position? _currentPosition;
//   String? _currentAddress;
//   LocationPermission? permission;
//
//   Future<bool> _isPermissionGranted() async {
//     PermissionStatus status = await Permission.sms.status;
//     if (status.isGranted) {
//       return true;
//     } else {
//       // Request permission if it's not granted yet
//       PermissionStatus newStatus = await Permission.sms.request();
//       return newStatus.isGranted;
//     }
//   }
//
//   // Function to send an SMS
//   Future<void> _sendSms(String phoneNumber, String message, {int? simSlot}) async {
//     SmsStatus result = await BackgroundSms.sendMessage(
//       phoneNumber: phoneNumber,
//       message: message,
//       simSlot: simSlot ?? 1,
//     );
//     if (result == SmsStatus.sent) {
//       Fluttertoast.showToast(msg: "Message sent successfully");
//     } else {
//       Fluttertoast.showToast(msg: "Failed to send message");
//     }
//   }
//
//   // Handle Location Permission
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       Fluttertoast.showToast(
//           msg: 'Location services are disabled. Please enable the services.');
//       return false;
//     }
//
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         Fluttertoast.showToast(msg: 'Location permissions are denied');
//         return false;
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       Fluttertoast.showToast(msg: 'Location permissions are permanently denied');
//       return false;
//     }
//
//     return true;
//   }
//
//   // Get the Current Location of the User
//   Future<void> _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         forceAndroidLocationManager: true,
//       );
//
//       setState(() {
//         _currentPosition = position;
//       });
//
//       // Once we have the position, we can fetch the address
//       _getAddressFromLatLon();
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   // Get Address from Latitude and Longitude
//   Future<void> _getAddressFromLatLon() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentPosition!.latitude,
//         _currentPosition!.longitude,
//       );
//
//       Placemark place = placemarks[0];
//       setState(() {
//         _currentAddress =
//         "${place.locality}, ${place.postalCode}, ${place.street}";
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   getRandomQuote() {
//     Random random = Random();
//     setState(() {
//       qIndex = random.nextInt(5);
//     });
//   }
//
//   getAndSendSms() async {
//     List<TContact> contactList = await DatabaseHelper().getContactList();
//
//     String messageBody =
//         "https://maps.google.com/?daddr=${_currentPosition!.latitude},${_currentPosition!.longitude}";
//     if (await _isPermissionGranted()) {
//       contactList.forEach((element) {
//         // _sendSms("${element.number}", "i am in trouble $messageBody");
//       });
//     } else {
//       Fluttertoast.showToast(msg: "something wrong");
//     }
//   }
//
//   @override
//   void initState() {
//     getRandomQuote();
//     super.initState();
//     _handleLocationPermission();
//     _getCurrentLocation();
//
//     ShakeDetector.autoStart(
//       onPhoneShake: () {
//         getAndSendSms();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Shake!'),
//           ),
//         );
//         // Do stuff on phone shake
//       },
//       minimumShakeCount: 1,
//       shakeSlopTimeMS: 500,
//       shakeCountResetTime: 3000,
//       shakeThresholdGravity: 2.7,
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             children: [
//               CustomAppBar(
//                 quoteIndex: qIndex,
//                 onTap: () {
//                    getRandomQuote();
//                 }),
//              Expanded(
//                child: ListView(
//                  shrinkWrap: true,
//                  children: [
//                    CustomCarouel(),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Text("Emergency",
//                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//                    ),
//                    Emergency(),
//                    Padding(
//                      padding: const EdgeInsets.all(8.0),
//                      child: Text("Explore LiveSafe",
//                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
//                    ),
//                    LiveSafe(),
//                    SafeHome(),
//                  ],
//                )
//              )
//
//                ],
//              ),
//         ),
//       ),
//     );
//   }
// }



import 'dart:math';
import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:women_safety_app/widgets/home_widgets/CustomCarouel.dart';
import 'package:women_safety_app/widgets/home_widgets/SafeHome/Safehome.dart';
import 'package:women_safety_app/widgets/home_widgets/custom_appBar.dart';
import 'package:women_safety_app/widgets/home_widgets/emergency.dart';
import 'package:women_safety_app/widgets/livesafe.dart';

import '../../database/datab_services.dart';
import '../../model/contact_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qIndex = 0;
  Position? _currentPosition;
  String? _currentAddress;

  @override
  void initState() {
    super.initState();
    getRandomQuote();
    _handleLocationPermissionAndFetchLocation();

    // Initialize shake detection
    ShakeDetector.autoStart(
      onPhoneShake: () {
        getAndSendSms();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Shake detected!')),
        );
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  // Function to get location permission and current location
  Future<void> _handleLocationPermissionAndFetchLocation() async {
    if (await _handleLocationPermission()) {
      _getCurrentLocation();
    }
  }

  // Request location permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: 'Location services are disabled. Please enable them.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied.');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(
          msg: 'Location permissions are permanently denied.');
      return false;
    }

    return true;
  }

  // Get current location
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );
      setState(() {
        _currentPosition = position;
      });
      _getAddressFromLatLon();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // Get address from latitude and longitude
  Future<void> _getAddressFromLatLon() async {
    if (_currentPosition == null) return;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
      );

      Placemark place = placemarks[0];
      setState(() {
        _currentAddress =
        "${place.locality}, ${place.postalCode}, ${place.street}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // Function to send SMS
  Future<void> _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    try {
      SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber,
        message: message,
        simSlot: simSlot ?? 1,
      );
      if (result == SmsStatus.sent) {
        Fluttertoast.showToast(msg: "Message sent to $phoneNumber");
      } else {
        Fluttertoast.showToast(msg: "Failed to send message to $phoneNumber");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error sending SMS: $e");
    }
  }

  // Function to get contacts and send SMS
  Future<void> getAndSendSms() async {
    if (_currentPosition == null) {
      Fluttertoast.showToast(msg: "Location not available.");
      return;
    }

    List<TContact> contactList = await DatabaseHelper().getContactList();
    String messageBody =
        "I'm in trouble. My location: https://maps.google.com/?daddr=${_currentPosition!.latitude},${_currentPosition!.longitude}";

    if (await _isSmsPermissionGranted()) {
      for (var contact in contactList) {
        await _sendSms(contact.number!, messageBody);
      }
    } else {
      Fluttertoast.showToast(msg: "SMS permission denied.");
    }
  }

  // Check SMS permission
  Future<bool> _isSmsPermissionGranted() async {
    PermissionStatus status = await Permission.sms.status;
    if (status.isGranted) {
      return true;
    } else {
      PermissionStatus newStatus = await Permission.sms.request();
      return newStatus.isGranted;
    }
  }

  // Function to get a random quote
  void getRandomQuote() {
    setState(() {
      qIndex = Random().nextInt(5);
    });
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
                onTap: getRandomQuote,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomCarouel(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Emergency",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Emergency(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Explore LiveSafe",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    LiveSafe(),
                    SafeHome(),
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
