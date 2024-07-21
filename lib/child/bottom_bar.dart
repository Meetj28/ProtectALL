import 'package:flutter/material.dart';
import 'package:women_safety_app/child/bottom_screens/Profile_page.dart';
import 'package:women_safety_app/child/bottom_screens/chat_page.dart';
import 'package:women_safety_app/child/bottom_screens/contacts.dart';
import 'package:women_safety_app/child/bottom_screens/home_screen.dart';
import 'package:women_safety_app/child/bottom_screens/review_page.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentIndex = 0;
  List<Widget> pages = [
    HomeScreen(),
    ContactPage(),
    ChatPage(),
    ReviewPage(),
    ProfilePage(),
  ];

  onTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTapped,
        type: BottomNavigationBarType.fixed,
        items:[
           BottomNavigationBarItem(
             label: 'Home',
             icon: Icon(
              Icons.home,
             ),
           ),
        BottomNavigationBarItem(
        label: 'Contacts',
        icon: Icon(
        Icons.contacts,
      ),
    ),
    BottomNavigationBarItem(
      label: 'Chats',
      icon: Icon(
        Icons.chat,
      ),
    ),
          BottomNavigationBarItem(
            label: 'Reviews',
            icon: Icon(
              Icons.reviews,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person,
            ),
          )
    ]
      ),

    );
  }
}
