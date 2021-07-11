import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'logo.dart';
import 'package:problem_ask/config/config.dart';

class WebBar extends StatefulWidget {
  const WebBar({Key? key}) : super(key: key);

  @override
  _WebBarState createState() => _WebBarState();
}

class _WebBarState extends State<WebBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: themeColor,
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed("home");
            },
            child: LogoWidget(),
          ),
          Row(
            children: [],
          ),
        ],
      ),
    );
  }
}
