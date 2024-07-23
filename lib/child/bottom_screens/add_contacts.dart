
import 'package:flutter/material.dart';
import 'package:women_safety_app/components/PrimaryButton.dart';

class AddContactsPage extends StatelessWidget {
  const AddContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Primarybutton(title: 'Add your Trusted Contacts', onPressed: () {}),
        ],
      ),
    );
  }
}
