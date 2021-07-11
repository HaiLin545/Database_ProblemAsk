import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/widgets/registorField.dart';

class Registor extends StatelessWidget {
  const Registor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
      ),
      child: ListView(
        shrinkWrap: true,
        children: [
          Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 20.w, bottom: 10.w),
                decoration: BoxDecoration(),
                child: Text(
                  "题问注册",
                  style: TextStyle(
                    color: themeColor,
                    fontSize: 25.w,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 10.w, bottom: 20.w),
                child: Center(
                  child: Container(
                    width: 320.w,
                    child: RegistorField(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
