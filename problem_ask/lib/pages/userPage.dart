import 'dart:convert';
import 'dart:html';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/widgets/userProblem.dart';
import 'package:problem_ask/widgets/webBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserPage extends StatelessWidget {
  UserPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dynamic para = (ModalRoute.of(context)?.settings.arguments);
    String uid = para[0];
    String tag = para[1];
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
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    child: Profile(uid: uid),
                    flex: 2,
                  ),
                  Expanded(
                    child: UserProblem(
                      userId: uid,
                      tag: tag,
                    ),
                    flex: 6,
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

class Profile extends StatefulWidget {
  final String uid;
  const Profile({Key? key, this.uid = "68580537"}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState(uid);
}

class _ProfileState extends State<Profile> {
  _ProfileState(this.uid);
  GlobalKey _formKey = GlobalKey<FormState>();
  GlobalKey<_RightSmallUserInfoState> _formKey2 = GlobalKey<_RightSmallUserInfoState>();
  TextEditingController _name = new TextEditingController();
  TextEditingController _city = new TextEditingController();
  TextEditingController _birth = new TextEditingController();
  TextEditingController _gender = new TextEditingController();
  final String uid;
  bool isEdit = false;
  bool _loadState = false;
  User user = new User();
  @override
  void initState() {
    super.initState();
    NetRequestor.request(Apis.getUserInfo(uid)).then((value) {
      if (value != null) user = User.fromJson(value);
      if (mounted) {
        setState(() {
          _loadState = true;
          _name.text = user.data.name;
          _city.text = user.data.city;
          _birth.text = user.data.birth;
          _gender.text = user.data.gender;
        });
      }
    });
  }

  void newBirth(String birth) {
    setState(() {
      _birth.text = birth.substring(0, 10);
      //  print(birth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            margin: EdgeInsets.only(left: 30.w, top: 20.w, bottom: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30.w),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    // padding: EdgeInsets.only(right: 10.w, left: 10.w, top: 20.w, bottom: 10.w),
                    child: RightSmallUserInfo(key: _formKey2, uid: uid),
                  ),
                  flex: 2,
                ),
                Expanded(
                  child: isEdit
                      ? Container(
                          //color: Colors.grey,
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          child: Text(
                                            "昵称：",
                                            style: TextStyle(
                                              fontSize: 25.w,
                                              color: themeColor,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _name,
                                            validator: (v) {
                                              return v!.length == 0 ? "昵称不能为空" : null;
                                            },
                                            style: TextStyle(fontSize: 30.w),
                                            decoration: InputDecoration(
                                              hintText: _name.text,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          child: Text(
                                            "城市：",
                                            style: TextStyle(
                                              fontSize: 25.w,
                                              fontWeight: FontWeight.bold,
                                              color: themeColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _city,
                                            validator: (v) {
                                              return v!.length == 0 ? "城市不能为空" : null;
                                            },
                                            style: TextStyle(fontSize: 30.w),
                                            decoration: InputDecoration(
                                              hintText: _city.text,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          child: Text(
                                            "性别：",
                                            style: TextStyle(
                                              fontSize: 25.w,
                                              fontWeight: FontWeight.bold,
                                              color: themeColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _gender,
                                            validator: (v) {
                                              return v!.length == 0 ? "性别不能为空" : null;
                                            },
                                            style: TextStyle(fontSize: 30.w),
                                            decoration: InputDecoration(
                                              hintText: _gender.text,
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 20.w, right: 20.w),
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(right: 10.w),
                                          child: Text(
                                            "生日：",
                                            style: TextStyle(
                                              fontSize: 25.w,
                                              fontWeight: FontWeight.bold,
                                              color: themeColor,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: _birth,
                                            validator: (v) {
                                              return v!.length == 0 ? "生日不能为空" : null;
                                            },
                                            style: TextStyle(fontSize: 30.w),
                                            decoration: InputDecoration(
                                              hintText: _birth.text,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: FlatButton(
                                              onPressed: () {
                                                showDatePicker(
                                                  context: context,
                                                  initialDate: new DateTime.now(),
                                                  firstDate: new DateTime.now().subtract(new Duration(days: 20000)),
                                                  lastDate: new DateTime.now().add(new Duration(days: 0)), // 加 30 天
                                                ).then((v) {
                                                  newBirth(v.toString());
                                                });
                                              },
                                              child: Text("选择日期")),
                                        ),
                                      ],
                                    ),
                                    flex: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : showInfo(),
                  flex: 2,
                ),
                Expanded(
                  child: isEdit
                      ? Container(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 50.w, bottom: 50.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                child: FlatButton(
                                  child: Text(
                                    "保存",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.w,
                                    ),
                                  ),
                                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                  onPressed: () {
                                    updateInfo();
                                    _formKey2.currentState?.updateInfo(_name.text, _gender.text);
                                    setState(() {
                                      isEdit = false;
                                    });
                                  },
                                  textColor: themeColor,
                                  color: themeColor2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
                                ),
                              ),
                              Container(
                                child: FlatButton(
                                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                                  child: Text(
                                    "取消",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30.w,
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isEdit = false;
                                    });
                                  },
                                  textColor: themeColor,
                                  color: themeColor2,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
                                ),
                              )
                            ],
                          ),
                        )
                      : editProfile(),
                  flex: 1,
                ),
              ],
            ),
          );
  }

  void updateInfo() async {
    if ((_formKey.currentState as FormState).validate()) {
      user.data.name = _name.text;
      user.data.city = _city.text;
      user.data.birth = _birth.text;
      user.data.gender = _gender.text;
      var res = await NetRequestor.request(Apis.updateInfo(uid, _name.text, _gender.text, _birth.text, _city.text));
      //    print(res);
      if (res['status'] == "20000")
        print("保存失败");
      else
        print("保存成功");
    }
  }

  Widget editProfile() {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 50.w, bottom: 50.w),
      child: FlatButton.icon(
        icon: Icon(Icons.add),
        label: Text(
          "修改信息",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30.w,
          ),
        ),
        onPressed: () {
          setState(() {
            isEdit = true;
          });
        },
        textColor: themeColor,
        color: themeColor2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      ),
    );
  }

  String getExp(int lev) {
    switch (lev) {
      case 0:
        return "10";
      case 1:
        return "1100";
      case 2:
        return "3100";
      case 3:
        return "8100";
      default:
        return "18100";
    }
  }

  Widget showInfo() {
    return Container(
      //color: Colors.grey,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    "经验值: " + user.data.exp + "/" + getExp(user.data.level),
                    style: TextStyle(fontSize: 25.w, fontWeight: FontWeight.bold, color: themeColor),
                  ),
                ),
                Container(
                  child: Text(
                    "学币: " + user.data.bill.toString(),
                    style: TextStyle(
                      fontSize: 25.w,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    "UID: " + user.data.uid,
                    style: TextStyle(
                      fontSize: 25.w,
                      fontWeight: FontWeight.bold,
                      color: themeColor,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "性别: " + user.data.gender,
                    style: TextStyle(
                      fontSize: 25.w,
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            flex: 1,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Text(
                    "城市: " + user.data.city,
                    style: TextStyle(
                      fontSize: 25.w,
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    "生日: " + user.data.birth,
                    style: TextStyle(
                      fontSize: 25.w,
                      color: themeColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            flex: 1,
          )
        ],
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

  void updateInfo(String name, String gender) {
    setState(() {
      user.data.name = name;
      user.data.gender = gender;
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
      return Icon(Icons.male, size: 50.w, color: Colors.blue);
    } else if (gender == "女") {
      return Icon(Icons.female, size: 50.w, color: Colors.pink);
    } else {
      return Icon(Icons.sentiment_neutral, size: 50.w, color: Colors.grey);
    }
  }
}
