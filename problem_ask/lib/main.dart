import 'package:flutter/material.dart';
import 'package:problem_ask/pages/homePage.dart';
import 'package:problem_ask/pages/loginPage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/pages/newProblemPage.dart';
import 'package:problem_ask/pages/problemPage.dart';
import 'package:problem_ask/pages/registorPage.dart';
import 'package:problem_ask/pages/userPage.dart';
//68580537

void main() => runApp(MyWeb());

class MyWeb extends StatelessWidget {
  const MyWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1920, 1080),
      builder: () => MaterialApp(
        title: "题问",
        theme: ThemeData(
          //primarySwatch: themeColor,
          fontFamily: "MiLanTing",
        ),
        routes: {
          "login": (context) => LoginPage(),
          "registor": (context) => RegistorPage(),
          "home": (context) => HomePage(),
          "newProblem": (context) => NewProblemPage(),
          "usr": (context) => UserPage(),
          "problem": (context) => ProblemPage(),
        },
        initialRoute: "login",
      ),
    );
  }
}
