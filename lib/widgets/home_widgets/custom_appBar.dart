import 'package:flutter/material.dart';
import 'package:women_safety_app/utils/quotes.dart';

class CustomAppBar extends StatelessWidget {
  int? quoteIndex;
  Function? onTap;

  CustomAppBar({this.onTap, this.quoteIndex});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
      },
      child: Container(
        child: Text(
          quoteIndex != null && quoteIndex! < sweetSayings.length
              ? sweetSayings[quoteIndex!]
              : "Stay safe and strong!",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}