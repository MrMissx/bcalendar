import 'dart:convert';
import 'package:http/http.dart' as http;

class ClassSchedule {
  static Future<Set<dynamic>> getSchedule(
      String username, String password) async {
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
      ),
    );
    if (login.statusCode != 200) {
      return {-100, "Login Failed"};
    }
    final data = json.decode(login.body);
    if (data["Status"] == false) {
      return {data["Failed"], data["Message"]};
    }
    print(data);
    return {data["Status"], data["Message"]};
  }
}
