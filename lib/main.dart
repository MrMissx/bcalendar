import 'package:flutter/material.dart';

import 'page/login.dart';
import 'main_page.dart';
import 'tools/db_utils.dart';
import 'tools/scraper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget detectPage() {
    DBHelper.getData().then((res) async {
      if (res.isEmpty) {
        return LoginPage();
      }
      var res = await ClassSchedule.login(res[0]['email'], res[0]['password']);

      if (res.first != 0) {
        DBHelper.deleteData();
        return LoginPage();
      }
      return MainPage();
    });

    // We should not reach this point but whatever for safety.
    return LoginPage();
  }

  void showAllert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text("No internet connection"),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Lato',
      ),
      debugShowCheckedModeBanner: false,
      home: detectPage(),
    );
  }
}
