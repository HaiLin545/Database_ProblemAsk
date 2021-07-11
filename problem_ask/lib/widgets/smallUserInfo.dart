import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';

class SmallUserInfo extends StatefulWidget {
  final String? uid;
  const SmallUserInfo({Key? key, this.uid}) : super(key: key);

  @override
  _SmallUserInfoState createState() => _SmallUserInfoState(uid);
}

class _SmallUserInfoState extends State<SmallUserInfo> {
  String? uid;
  bool _loadState = false;
  _SmallUserInfoState(this.uid);
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
            // color: Colors.red,
            padding: EdgeInsets.only(left: 10.w, right: 10.w),
            child: Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: ClipOval(
                    child: Image.network(user.data.backgroundImg),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  child: Text(
                    user.data.name,
                    textScaleFactor: 1.1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                buildGenderIcon(context, user.data.gender),
                Container(
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
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
          );
  }

  Icon buildGenderIcon(BuildContext context, String gender) {
    if (gender == "男") {
      return Icon(Icons.male, size: 15, color: Colors.blue);
    } else if (gender == "女") {
      return Icon(Icons.female, size: 15, color: Colors.pink);
    } else {
      return Icon(Icons.sentiment_neutral, size: 15, color: Colors.grey);
    }
  }
}
