import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BusStationCard extends StatelessWidget {
  final Function? onMapFunction;
  const BusStationCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            InkWell(
            onTap: () {
      onMapFunction!('bus station near me');
      },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 50,
                  width: 50,
                  child: Center(
                    child: Image.asset('assets/bus stop.jpg',height: 30,),
                  ),
                ),
              ),
            ),
            Text("Bus Station")
          ],
        ),
      ),
    );
  }
}
