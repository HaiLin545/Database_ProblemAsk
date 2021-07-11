import 'package:flutter/material.dart';

import 'package:problem_ask/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';

class RightSmallUserInfo extends StatefulWidget {
  final String? uid;
  const RightSmallUserInfo({Key? key, this.uid}) : super(key: key);

  @override
  _RightSmallUserInfoState createState() => _RightSmallUserInfoState(uid);
}

class _RightSmallUserInfoState extends State<RightSmallUserInfo> {
  String? uid;
  bool _loadState = false;
  _RightSmallUserInfoState(this.uid);
  User user = new User();
  @override
  void initState() {
    super.initState();
    NetRequestor.request(Apis.getUserInfo(uid)).then((value) {
      if (value != null) user = User.fromJson(value);
      if (mounted) {
        setState(() {
          _loadState = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            //color: Colors.red,
            // margin: EdgeInsets.all(30.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      //color: Colors.yellow,
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.network(user.data.backgroundImg),
                    ),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        //color: Colors.red,
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Text(
                          user.data.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30.w,
                          ),
                        ),
                      ),
                      buildGenderIcon(context, user.data.gender),
                      Container(
                        margin: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: Text(
                          "LV" + user.data.level.toString(),
                          textScaleFactor: 1,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  flex: 1,
                ),
              ],
            ),
          );
  }

  Icon buildGenderIcon(BuildContext context, String gender) {
    if (gender == "男") {
      return Icon(Icons.male, size: 30.w, color: Colors.blue);
    } else if (gender == "女") {
      return Icon(Icons.female, size: 30.w, color: Colors.pink);
    } else {
      return Icon(Icons.sentiment_neutral, size: 30.w, color: Colors.grey);
    }
  }
}
