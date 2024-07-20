import 'package:flutter/material.dart';
import 'package:women_safety_app/widgets/home_widgets/emergencies/ambulace_emergency.dart';
import 'package:women_safety_app/widgets/home_widgets/emergencies/army_emergency.dart';
import 'package:women_safety_app/widgets/home_widgets/emergencies/fire_brigade_emergency.dart';
import 'package:women_safety_app/widgets/home_widgets/emergencies/police_emergency.dart';

class Emergency extends StatelessWidget {
  const Emergency({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: ListView(
        physics: BouncingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        children: [
          PoliceEmergency(),
          AmbulanceEmergency(),
          ArmyEmergency(),
          FireBrigadeEmergency(),
        ],
      )
    );
  }
}
