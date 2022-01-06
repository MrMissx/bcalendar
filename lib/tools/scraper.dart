import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:bschedule/tools/misc.dart';
import 'package:bschedule/tools/db_utils.dart';

class ClassSchedule {
  static Future<Set<dynamic>> login(String username, String password) async {
    final login = await http.post(
        Uri.parse("https://myclass.apps.binus.ac.id/Auth/Login"),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          {
            "username": username,
            "password": password,
          },
        ));
    if (login.statusCode != 200) {
      return {-100, "Login Failed"};
    }
    String cookie = "";
    login.headers.forEach((key, value) {
      if (key == "set-cookie") {
        cookie = value;
      }
    });
    if (cookie.isEmpty) {
      return {-10, "Failed to get page cookies"};
    }
    final data = json.decode(login.body);
    if (data["Status"] == false) {
      return {data["Failed"], data["Message"]};
    }

    DBHelper.insertCookies({
      "_id": 1,
      "cookie": cookie,
      "epoch": DateTime.now().millisecondsSinceEpoch,
    });
    return {0, cookie};
  }

  static Future<dynamic> getSchedule() async {
    String cookie = "";
    List<Map<String, dynamic>> cookieData = await DBHelper.getCookie();
    if (cookieData.isEmpty || cookieData[0]["_id"] != 1) {
      final data = await DBHelper.getData();
      if (data.isEmpty) {
        return -1;
      }
      final res = await login(data[0]['email'], data[0]['password']);
      cookie = res.last;
    } else {
      int epoch = cookieData[0]['epoch'];
      // check if cookie is expired
      if (getMinuteDiff(epoch) > 5) {
        final data = await DBHelper.getData();
        if (data.isEmpty) {
          return -1;
        }
        final res = await login(data[0]['email'], data[0]['password']);
        cookie = res.last;
      } else {
        cookie = cookieData[0]['cookie'];
      }
    }

    final schedule = await http.get(
        Uri.parse("https://myclass.apps.binus.ac.id/Home/GetViconSchedule"),
        headers: {
          "Cookie": cookie,
        });
    if (schedule.statusCode != 200) {
      return {-100, "Failed to get schedule"};
    }
    return json.decode(schedule.body);
  }
}
