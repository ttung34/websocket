import 'package:flutter/material.dart';
import 'package:flutter_websocket/account/account.dart';
import 'package:flutter_websocket/ai/chat_box.dart';
import 'package:flutter_websocket/notification/notification.dart';
import 'package:flutter_websocket/work/work_list_view.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  var _currentIndex = 0;
  List<Widget> page = [
    const WorkListView(),
    const NotificationPage(),
    const ChatBoxView(),
    const AccountPageView(),
  ];

  void _nextPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    page.elementAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dự báo độ các độ trong không khí'),
      ),
      body: Center(
        child: page.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Work',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat Box',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle_outlined),
            label: 'Account',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _nextPage,
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        iconSize: 20,
        selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(
          color: Colors.amberAccent,
          size: 30,
        ),
        selectedItemColor: Colors.amberAccent,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.deepOrangeAccent,
        ),
        unselectedItemColor: Colors.deepOrangeAccent,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
