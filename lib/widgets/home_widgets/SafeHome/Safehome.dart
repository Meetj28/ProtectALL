// import 'package:background_sms/background_sms.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter/widgets.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:women_safety_app/components/PrimaryButton.dart';
// import 'package:women_safety_app/database/datab_services.dart';
// import 'package:women_safety_app/model/contact_model.dart';
//
// class SafeHome extends StatefulWidget {
//   @override
//   State<SafeHome> createState() => _SafeHomeState();
// }
//
// class _SafeHomeState extends State<SafeHome> {
//   Position? _curentPosition;
//   String? _curentAddress;
//   LocationPermission? permission;
//
//
//
//   _isPermissionGranted() async => await Permission.sms.status.isGranted;
//   _sendSms(String phoneNumber, String message, {int? simSlot}) async {
//     SmsStatus result = await BackgroundSms.sendMessage(
//         phoneNumber: phoneNumber, message: message, simSlot: 1);
//     if (result == SmsStatus.sent) {
//       print("Sent");
//       Fluttertoast.showToast(msg: "send");
//     } else {
//       Fluttertoast.showToast(msg: "failed");
//     }
//   }
//
//   Future<bool> _handleLocationPermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location services are disabled. Please enable the services')));
//       return false;
//     }
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permissions are denied')));
//         return false;
//       }
//     }
//     if (permission == LocationPermission.deniedForever) {
//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//           content: Text(
//               'Location permissions are permanently denied, we cannot request permissions.')));
//       return false;
//     }
//     return true;
//   }
//
//   _getCurrentLocation() async {
//     final hasPermission = await _handleLocationPermission();
//     if (!hasPermission) return;
//     await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//         forceAndroidLocationManager: true)
//         .then((Position position) {
//       setState(() {
//         _curentPosition = position;
//         print(_curentPosition!.latitude);
//         _getAddressFromLatLon();
//       });
//     }).catchError((e) {
//       Fluttertoast.showToast(msg: e.toString());
//     });
//   }
//
//   _getAddressFromLatLon() async {
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//           _curentPosition!.latitude, _curentPosition!.longitude);
//
//       Placemark place = placemarks[0];
//       setState(() {
//         _curentAddress =
//         "${place.locality},${place.postalCode},${place.street},";
//       });
//     } catch (e) {
//       Fluttertoast.showToast(msg: e.toString());
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _getCurrentLocation();
//   }
//
//   showModelSafeHome(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) {
//         return Container(
//           height: MediaQuery.of(context).size.height / 1.4,
//           child: Padding(
//             padding: const EdgeInsets.all(14.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   "SEND YOUR CUURENT LOCATION IMMEDIATELY TO YOU EMERGENCY CONTACTS",
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 20),
//                 ),
//                 SizedBox(height: 10),
//                 if (_curentPosition != null) Text(_curentAddress!),
//                 PrimaryButton(
//                     title: "GET LOCATION",
//                     onPressed: () {
//                       _getCurrentLocation();
//                     }),
//                 SizedBox(height: 10),
//                 PrimaryButton(
//                     title: "SEND ALERT",
//                     onPressed: () async {
//                       String recipients = "";
//                       List<TContact> contactList =
//                       await DatabaseHelper().getContactList();
//                       print(contactList.length);
//                       if (contactList.isEmpty) {
//                         Fluttertoast.showToast(
//                             msg: "emergency contact is empty");
//                       } else {
//                         String messageBody =
//                             "https://www.google.com/maps/search/?api=1&query=${_curentPosition!.latitude}%2C${_curentPosition!.longitude}. $_curentAddress";
//
//                         if (await _isPermissionGranted()) {
//                           contactList.forEach((element) {
//                             _sendSms("${element.number}",
//                                 "i am in trouble $messageBody");
//                           });
//                         } else {
//                           Fluttertoast.showToast(msg: "something wrong");
//                         }
//                       }
//                     }),
//               ],
//             ),
//           ),
//           decoration: BoxDecoration(
//               color: Colors.white,
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(30),
//                 topRight: Radius.circular(30),
//               )),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () => showModelSafeHome(context),
//       child: Card(
//         elevation: 5,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Container(
//           height: 180,
//           width: MediaQuery.of(context).size.width * 0.7,
//           decoration: BoxDecoration(),
//           child: Row(
//             children: [
//               Expanded(
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text("Send Location"),
//                         subtitle: Text("Share Location"),
//                       ),
//                     ],
//                   )),
//               ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: Image.asset('assets/rouuute.jpeg')),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class PrimaryButton extends StatelessWidget {
//   final String title;
//   final Function onPressed;
//   bool loading;
//   PrimaryButton(
//       {required this.title, required this.onPressed, this.loading = false});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 50,
//       width: MediaQuery.of(context).size.width * 0.5,
//       child: ElevatedButton(
//         onPressed: () {
//           onPressed();
//         },
//         child: Text(
//           title,
//           style: TextStyle(fontSize: 17),
//         ),
//         style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.pink,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30))),
//       ),
//     );
//   }
// }


import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';
import 'package:women_safety_app/database/datab_services.dart';
import 'package:women_safety_app/model/contact_model.dart';


class SafeHome extends StatefulWidget {
  @override
  State<SafeHome> createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  Position? _currentPosition;
  String? _currentAddress;

  // Check if SMS Permission is granted
  Future<bool> _isPermissionGranted() async {
    PermissionStatus status = await Permission.sms.status;
    if (status.isGranted) {
      return true;
    } else {
      // Request permission if it's not granted yet
      PermissionStatus newStatus = await Permission.sms.request();
      return newStatus.isGranted;
    }
  }

  // Function to send an SMS
  Future<void> _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
      phoneNumber: phoneNumber,
      message: message,
      simSlot: simSlot ?? 1,
    );
    if (result == SmsStatus.sent) {
      Fluttertoast.showToast(msg: "Message sent successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to send message");
    }
  }

  // Handle Location Permission
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(
          msg: 'Location services are disabled. Please enable the services.');
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied');
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permissions are permanently denied');
      return false;
    }

    return true;
  }

  // Get the Current Location of the User
  Future<void> _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true,
      );

      setState(() {
        _currentPosition = position;
      });

      // Once we have the position, we can fetch the address
      _getAddressFromLatLon();
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  // Get Address from Latitude and Longitude
  Future<void> _getAddressFromLatLon() async {
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

  @override
  void initState() {
    super.initState();
    _getCurrentLocation(); // Get the location when the app starts
  }

  // Show Modal Bottom Sheet for Sending Alerts
  void _showModalSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          padding: const EdgeInsets.all(14.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "SEND YOUR CURRENT LOCATION IMMEDIATELY TO YOUR EMERGENCY CONTACTS",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              if (_currentAddress != null)
                Text(_currentAddress!),
              SizedBox(height: 10),
              PrimaryButton(
                title: "GET LOCATION",
                onPressed: _getCurrentLocation,
              ),
              SizedBox(height: 10),
              PrimaryButton(
                title: "SEND ALERT",
                onPressed: () async {
                  List<TContact> contactList =
                  await DatabaseHelper().getContactList();

                  if (contactList.isEmpty) {
                    Fluttertoast.showToast(msg: "Emergency contact list is empty");
                    return;
                  }

                  if (_currentPosition != null && _currentAddress != null) {
                    String messageBody =
                        "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";

                    if (await _isPermissionGranted()) {
                      contactList.forEach((element) {
                        _sendSms(element.number, "I am in trouble. $messageBody");
                      });
                    } else {
                      Fluttertoast.showToast(msg: "SMS Permission denied");
                    }
                  } else {
                    Fluttertoast.showToast(msg: "Location not available");
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showModalSafeHome(context),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          child: Row(
            children: [
              Expanded(
                child: ListTile(
                  title: Text("Send Location"),
                  subtitle: Text("Share Location"),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/rouuute.jpeg'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PrimaryButton extends StatelessWidget {
  final String title;
  final Function onPressed;
  final bool loading;

  PrimaryButton({
    required this.title,
    required this.onPressed,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.5,
      child: ElevatedButton(
        onPressed: loading ? null : () => onPressed(),
        child: Text(
          title,
          style: TextStyle(fontSize: 17),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }
}
