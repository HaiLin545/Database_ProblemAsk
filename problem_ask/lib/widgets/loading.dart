import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        //   padding: EdgeInsets.all(1),
        child: CircularProgressIndicator(
          backgroundColor: themeColor,
          valueColor: AlwaysStoppedAnimation(themeColor2),
        ),
      ),
    );
  }
}
