import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:problem_ask/widgets/rightSmallUerInfo.dart';
import 'package:problem_ask/widgets/selecetedProblem.dart';
import 'package:problem_ask/widgets/webBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  GlobalKey<_RightSmallUserInfoState> _right = GlobalKey<_RightSmallUserInfoState>();
  bool _loadState = false;
  String uid = "";
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      if (value.getString('uid') != null) {
        //  print(value.getString('uid'));
        uid = value.getString('uid')!;
      }
      setState(() {
        _loadState = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (uid == "" && _loadState == true) uid = (ModalRoute.of(context)?.settings.arguments).toString();
    return _loadState == false
        ? LoadingWidget()
        : Scaffold(
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
                    child: Flex(
                      direction: Axis.horizontal,
                      children: <Widget>[
                        Expanded(
                          child: SelectedProblem(usrId: uid),
                          flex: 8,
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 30.w, top: 20.w, bottom: 20.w),
                            //padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30.w),
                              color: Colors.white,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 20.w, bottom: 10.w),
                                    child: RightSmallUserInfo(key: _right, uid: uid),
                                  ),
                                  flex: 1,
                                ),
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: themeColor2,
                                        width: 3.w,
                                      ),
                                      borderRadius: BorderRadius.circular(20.w),
                                    ),
                                    padding: EdgeInsets.all(50.w),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              List arg = [uid, "1"];
                                              Navigator.of(context)
                                                  .pushNamed("usr", arguments: arg)
                                                  .then((value) => {_right.currentState?.init()});
                                            },
                                            child: _text("个人中心"),
                                          ),
                                        ),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              List arg = [uid, "1"];
                                              Navigator.of(context).pushNamed("usr", arguments: arg);
                                            },
                                            child: _text("发布过的问题"),
                                          ),
                                        ),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              List arg = [uid, "2"];
                                              Navigator.of(context).pushNamed("usr", arguments: arg);
                                            },
                                            child: _text("回答过的问题"),
                                          ),
                                        ),
                                        Expanded(
                                          child: FlatButton(
                                            onPressed: () {
                                              List arg = [uid, "3"];
                                              Navigator.of(context).pushNamed("usr", arguments: arg);
                                            },
                                            child: _text("收藏的问题"),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 2,
                                ),
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 50.w, bottom: 50.w),
                                    child: FlatButton.icon(
                                      icon: Icon(Icons.add),
                                      label: Text(
                                        "发布新问题",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.w,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pushNamed("newProblem", arguments: uid).then((value) {
                                          _right.currentState?.init();
                                        });
                                      },
                                      textColor: themeColor,
                                      color: themeColor2,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
                                    ),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                  flex: 9,
                ),
              ],
            ),
          );
  }

  Widget _text(String text) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.w,
      ),
    );
  }
}

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

  void init() {
    setState(() {
      _loadState = true;
    });
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
