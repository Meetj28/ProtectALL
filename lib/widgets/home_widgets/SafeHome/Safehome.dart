import 'package:background_sms/background_sms.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  void initState() {
    super.initState();
    _getPermission();
    _getCurrentLocation();
  }

  void showModalSafeHome(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height / 1.4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children:[
              Text(
                "Send your current location immediately to your emergency contancts",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(height: 10),
              if(_currentPosition!=null)
                Text(_currentAddress!),
              Primarybutton(title: "Get Location", onPressed: () {
                _getCurrentLocation();
              }),
              SizedBox(height: 10),
              Primarybutton(title: "Send Alert", onPressed: () async {
                List<TContact> contactList = await DatabaseHelper().getContactList();
                String recipients = "";
                int i=1;
                for(TContact contact in contactList) {
                  recipients += contact.number;
                  if(i!=contactList.length){
                    recipients +=";";
                    i++;
                  }
                }
                String messageBody =   "https://www.google.com/maps/search/?api=1&query=${_currentPosition!.latitude}%2C${_currentPosition!.longitude}. $_currentAddress";
                if(await _isPermissionGranted()) {
                  contactList.forEach((element) {
                    _sendSms("${element.number}", "Please help me I am in trouble at $messageBody",simSlot: 1);
                  });
                }
                else
                  {
                    Fluttertoast.showToast(msg: "Something went wrong");
                  }
              }),
            ],
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showModalSafeHome(context), // Pass context here
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            // Add any desired decoration here
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      title: Text("Send Location"),
                      subtitle: Text("Share Location"),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset('assets/rouuute.jpeg', height: 130, width: 130),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
