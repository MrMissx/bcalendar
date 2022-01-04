import 'package:flutter/material.dart';

import 'page/about.dart';
import 'page/exam.dart';
import 'page/schedule.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  static const List<Widget> pageOption = <Widget>[
    SchedulePage(),
    ExamPage(),
    AboutPage(),
  ];
  static const List<Widget> headerText = <Widget>[
    Text('Class Schedule'),
    Text('Exam Schedule'),
    Text('About'),
  ];

  void onNavHandler(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: headerText[_selectedIndex],
      ),
      body: pageOption[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              label: "Class Schedule",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.article),
              label: "Exam Schedule",
              backgroundColor: Colors.blue),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "About",
              backgroundColor: Colors.blue),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        onTap: onNavHandler,
      ),
    );
  }
}
