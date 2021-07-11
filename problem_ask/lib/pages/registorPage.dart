import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/widgets/registor.dart';
import 'package:problem_ask/widgets/webBar.dart';

class RegistorPage extends StatelessWidget {
  const RegistorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                child: Registor(),
              ),
            ),
            flex: 9,
          ),
        ],
      ),
    );
  }
}
