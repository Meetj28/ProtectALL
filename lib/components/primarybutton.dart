import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/constants.dart';

class Primarybutton extends StatelessWidget {
  final String title;
  final Function onPressed;
  bool loading;
  Primarybutton(
      {required this.title, required this.onPressed, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        child: Text(
          title,
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
            backgroundColor: kColorRed,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}