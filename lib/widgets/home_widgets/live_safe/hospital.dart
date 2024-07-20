import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HospitalCard extends StatelessWidget {
  final Function? onMapFunction;
  const HospitalCard({Key? key, this.onMapFunction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Column(
          children: [
            InkWell(
            onTap: () {
      onMapFunction!('hospital near me');
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
                    child: Image.asset('assets/hospital.jpg',height: 30,),
                  ),
                ),
              ),
            ),
            Text("Hospital")
          ],
        ),
      ),
    );
  }
}
