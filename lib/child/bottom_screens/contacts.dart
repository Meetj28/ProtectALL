import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:women_safety_app/database/datab_services.dart';
import 'package:women_safety_app/model/contact_model.dart';
import 'package:women_safety_app/utils/constants.dart';

class ContactsPage extends StatefulWidget {
  const ContactsPage({Key? key}) : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];
  List<Contact> contactsFiltered = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    askPermissions();
    searchController.addListener(filterContact);
  }

  @override
  void dispose() {
    searchController.removeListener(filterContact);
    searchController.dispose();
    super.dispose();
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  void filterContact() {
    List<Contact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((element) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlattened = flattenPhoneNumber(searchTerm);
        String contactName = element.displayName?.toLowerCase() ?? "";
        bool nameMatch = contactName.contains(searchTerm);

        if (nameMatch) {
          return true;
        }

        if (searchTermFlattened.isEmpty) {
          return false;
        }

        bool phoneMatch = element.phones?.any((p) {
          String phoneFlattened = flattenPhoneNumber(p.value ?? "");
          return phoneFlattened.contains(searchTermFlattened);
        }) ?? false;

        return phoneMatch;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  Future<void> askPermissions() async {
    PermissionStatus permissionStatus = await getContactsPermissions();
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

  Future<PermissionStatus> getContactsPermissions() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  Future<void> getAllContacts() async {
    List<Contact> _contacts =
    await ContactsService.getContacts(withThumbnails: false);
    setState(() {
      contacts = _contacts;
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemExist = contactsFiltered.isNotEmpty;

    return Scaffold(
      body: contacts.isEmpty
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                autofocus: true,
                controller: searchController,
                decoration: InputDecoration(
                    labelText: "Search contact",
                    prefixIcon: Icon(Icons.search)),
              ),
            ),
            listItemExist
                ? Expanded(
              child: ListView.builder(
                itemCount: contactsFiltered.length,
                itemBuilder: (BuildContext context, int index) {
                  Contact contact = contactsFiltered[index];
                  return ListTile(
                    title: Text(contact.displayName ?? ""),
                    leading: contact.avatar != null &&
                        contact.avatar!.isNotEmpty
                        ? CircleAvatar(
                      backgroundColor: kColorRed,
                      backgroundImage:
                      MemoryImage(contact.avatar!),
                    )
                        : CircleAvatar(
                      backgroundColor: kColorRed,
                      child: Text(contact.initials()),
                    ),
                    onTap: () {
                      if (contact.phones!.isNotEmpty) {
                        final String phoneNum =
                        contact.phones!.elementAt(0).value!;
                        final String name =
                        contact.displayName!;
                        _addContact(
                            TContact(phoneNum, name));
                      } else {
                        Fluttertoast.showToast(
                            msg:
                            "Oops! Phone number of this contact does not exist");
                      }
                    },
                  );
                },
              ),
            )
                : Container(
              child: Text("Searching"),
            ),
          ],
        ),
      ),
    );
  }

  void _addContact(TContact newContact) async {
    int result = await _databaseHelper.insertContact(newContact);
    if (result != 0) {
      Fluttertoast.showToast(msg: "Contact added successfully");
    } else {
      Fluttertoast.showToast(msg: "Failed to add contact");
    }
    Navigator.of(context).pop(true);
  }
}

