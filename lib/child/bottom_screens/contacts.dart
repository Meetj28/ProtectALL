//
// import 'dart:ffi';
//
// import 'package:contacts_service/contacts_service.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:women_safety_app/utils/constants.dart';
//
// class ContactPage extends StatefulWidget {
//   const ContactPage({super.key});
//
//   @override
//   State<ContactPage> createState() => _ContactPageState();
// }
//
// class _ContactPageState extends State<ContactPage> {
//   List<Contact> contacts = [];
//
//   @override
//   void initState() {
//     super.initState();
//     askPermissions();
//   }
//
//
//
//   Future<void> askPermissions() async{
//     PermissionStatus permissionStatus = await getContactsPermission();
//     if(permissionStatus == PermissionStatus.granted){
//
//     }
//     else {
//         handleInvalidPermissions(permissionStatus);
//       }
//   }
//
//   handleInvalidPermissions(PermissionStatus permissionStatus) {
//     if(permissionStatus == PermissionStatus.denied){
//       dialogueBox(context, "Access to the contacts denied by the user");
//     }
//     else if(permissionStatus == PermissionStatus.permanentlyDenied){
//       dialogueBox(context, "May contact does not exist in this device");
//     }
//   }
//
//   Future<PermissionStatus> getContactsPermission() async {
//     PermissionStatus permission = await Permission.contacts.status;
//     if(permission != PermissionStatus.granted &&
//     permission != PermissionStatus.permanentlyDenied) {
//       PermissionStatus permissionStatus = await Permission.contacts.request();
//       return permissionStatus;
//     }
//     else {
//         return permission;
//       }
//   }
//   getAllContacts() async {
//     List<Contact> _contacts = await ContactsService.getContacts();
//     setState(() {
//       contacts = _contacts;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: contacts.length == 0
//        ? Center(child: CircularProgressIndicator())
//           :ListView.builder(
//         itemCount: contacts.length,
//         itemBuilder: (
//             BuildContext context, int index) {
//           Contact contact = contacts[index];
//           return ListTile(
//             title: Text(contacts[index].displayName!),
//             subtitle: Text(contact.phones!.elementAt(0).value!),
//             leading: contact.avatar != null && contact.avatar!.length > 0
//               ? CircleAvatar(
//               backgroundImage: MemoryImage(contact.avatar!),
//             )
//                 : CircleAvatar(
//               child: Text(contact.initials()),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }



import 'dart:ffi';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_safety_app/utils/constants.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    askPermissions();
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermission();
    if (permissionStatus == PermissionStatus.granted) {
      getAllContacts();
    } else {
      handleInvalidPermissions(permissionStatus);
    }
  }

  void handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      dialogueBox(context, "Access to the contacts denied by the user");
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      dialogueBox(context, "May contact does not exist in this device");
    }
  }

  Future<PermissionStatus> getContactsPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> getAllContacts() async {
    List<Contact> _contacts = await ContactsService.getContacts();
    setState(() {
      contacts = _contacts;
      if (contacts.isEmpty) {
        print("No contacts found.");
      } else {
        print("Contacts loaded successfully.");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts"),
      ),
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (BuildContext context, int index) {
          Contact contact = contacts[index];
          return ListTile(
            title: Text(contact.displayName ?? 'No name'),
            subtitle: Text(contact.phones?.isNotEmpty == true ? contact.phones!.elementAt(0).value ?? '' : 'No phone'),
            leading: (contact.avatar != null && contact.avatar!.isNotEmpty)
                ? CircleAvatar(
              backgroundImage: MemoryImage(contact.avatar!),
            )
                : CircleAvatar(
              child: Text(contact.initials()),
            ),
          );
        },
      ),
    );
  }
}
