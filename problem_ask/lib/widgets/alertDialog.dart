import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void showAlertDialog(BuildContext context, String tip) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("提示", style: TextStyle(color: themeColor, fontSize: 22.w)),
        content: Text(
          tip,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("知道了"),
            color: themeColor2,
            colorBrightness: Brightness.dark,
            splashColor: themeColor,
          ),
        ],
      );
    },
  );
}
