import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/widgets/login.dart';
import 'package:problem_ask/widgets/webBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  fuck() async {
    Future.delayed(Duration(seconds: 3), () {
      SharedPreferences.getInstance().then((value) {
        if (value.getString('uid') != null) {
          // print(value.getString('uid'));
          Navigator.of(context).pushNamed("home", arguments: value.getString('uid'));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    fuck();
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebBar(),
            flex: 1,
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: themeColor,
              ),
              width: double.infinity,
              child: Align(
                alignment: Alignment(0, 0),
                child: Login(),
              ),
            ),
            flex: 9,
          ),
        ],
      ),
    );
  }
}
