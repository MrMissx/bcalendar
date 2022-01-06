import 'dart:io';

import 'package:flutter/material.dart';

import 'package:bschedule/page/login.dart';
import 'package:bschedule/tools/scraper.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  Future<dynamic> loadData() async {
    var result = await ClassSchedule.getSchedule();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadData(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Text(snapshot.data[index]["DisplayStartDate"]),
                title: Text(snapshot.data[index]["CourseCode"] +
                    " - " +
                    snapshot.data[index]["CourseTitleEn"]),
                subtitle: Text(snapshot.data[index]["DeliveryMode"]),
                trailing: Text(
                    snapshot.data[index]["StartTime"].substring(0, 5) +
                        " - " +
                        snapshot.data[index]["EndTime"].substring(0, 5)),
                dense: true,
                onTap: 
              );
            },
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return LoginPage();
        } else {
          return Center(
            child: Text('Unknown Error'),
          );
        }
      },
    );
  }
}
