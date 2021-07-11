import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0x00000000), width: 5),
        borderRadius: BorderRadius.circular(30),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: InkWell(
            onTap: () {},
            child: Row(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    "ProblemAsk",
                    style: TextStyle(
                      fontSize: 25,
                      color: themeColor2,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
