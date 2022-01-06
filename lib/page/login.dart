import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import 'package:bschedule/main_page.dart';
import '../tools/db_utils.dart';
import '../tools/scraper.dart';
import '../theme.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  void setCreds(BuildContext context) async {
    final form = _formKey.currentState;
    if (!form!.validate()) {
      return;
    }

    // attemp login
    final a = await ClassSchedule.login(
        emailController.text, passwordController.text);

    if (a.first != 0) {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Login Failed",
        desc: a.last,
        buttons: [
          DialogButton(
            child: Text(
              "Retry",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ).show();
      return;
    }

    final SnackBar notif = SnackBar(
      content: Text("Login successful"),
      duration: Duration(seconds: 1),
      backgroundColor: Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(notif);

    await DBHelper.insertCredentials({
      '_id': 1,
      'email': emailController.text,
      'password': passwordController.text,
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Enter Your Credentials',
                      style: h2.copyWith(color: textBlack),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Username';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: 'Username',
                          hintStyle: h3.copyWith(color: textGrey),
                          prefixIcon: Icon(Icons.person),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 32,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: !passwordVisible,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: h3.copyWith(color: textGrey),
                          suffixIcon: IconButton(
                            color: textGrey,
                            splashRadius: 1,
                            icon: Icon(passwordVisible
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                            onPressed: togglePassword,
                          ),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 32,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    setCreds(context);
                  },
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "*The credentials are only stored on this device.",
                    style: miniText.copyWith(color: textGrey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
