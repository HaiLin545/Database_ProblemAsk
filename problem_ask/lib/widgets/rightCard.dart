import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/widgets/rightSmallUerInfo.dart';

class RightCard extends StatelessWidget {
  String? uid;
  RightCard({Key? key, this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.w),
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.red,
            ),
            child: RightSmallUserInfo(
              uid: uid,
            ),
          ),
        ],
      ),
    );
  }
}
