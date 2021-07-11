import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:problem_ask/widgets/AnsCard.dart';
import 'package:flutter/material.dart';
import 'package:problem_ask/widgets/alertDialog.dart';
import 'package:problem_ask/data/ans.dart';
import 'package:problem_ask/widgets/smallUserInfo.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/problems.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/widgets/webBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProblemPage extends StatefulWidget {
  const ProblemPage({Key? key}) : super(key: key);

  @override
  _ProblemPageState createState() => _ProblemPageState();
}

class _ProblemPageState extends State<ProblemPage> {
  bool _loadState = false;
  String userId = "";
  Problem pro = new Problem();
  User usr = new User();
  bool isStar = false;
  Image proImg = Image.asset("assets/images/white.png");
  GlobalKey _formKey = new GlobalKey<FormState>();
  GlobalKey<_AnsListState> _ansList = new GlobalKey<_AnsListState>();
  TextEditingController _cm = new TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void getPro(String pid, String uid) {
    NetRequestor.request(Apis.getProblem(pid)).then((value) {
      if (value != null) {
        pro = Problem.fromJson(value);
        userId = uid;
        print("A: " + pid);
        if (pro.data.pic_num > 0) {
          if (pro.data.pic_url[0] != "assets/images/white.jpg") {
            proImg = Image.asset("assets/images/$pid.png");
          }
        }
        NetRequestor.request(Apis.isFollow(pid, uid)).then((value) {
          if (value['status'] == "10000") {
            setState(() {
              _loadState = true;
              isStar = value['data'];
            });
          }
        });
      }
    });
  }

  Widget _title() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.fromLTRB(30.w, 20.w, 30.w, 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.centerLeft,
              child: Expanded(
                child: Text(
                  pro.data.title + "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.w),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                ),
              ),
            ),
            flex: 9,
          ),
          Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  Text(
                    (pro.data.confirmedAid.compareTo("0") == 0) ? "未解决" : "已解决",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: themeColor,
                      fontSize: 20.w,
                    ),
                  ),
                  Container(
                    child: IconButton(
                      onPressed: () {
                        String _url = isStar ? Apis.unfollow(pro.data.pid, userId) : Apis.follow(pro.data.pid, userId);
                        NetRequestor.request(_url).then((value) {
                          // print("star" + value['status']);
                          setState(() {
                            isStar = !isStar;
                          });
                        });
                      },
                      icon: isStar == false ? Icon(Icons.star_outline) : Icon(Icons.star),
                    ),
                  )
                ],
              ),
            ),
            flex: 1,
          ),
        ],
      ),
    );
  }

  Widget _usr() {
    return Container(
      width: double.maxFinite,
      margin: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Container(
            // color: Colors.red,
            height: 50.w,
            margin: EdgeInsets.only(left: 20.w, right: 20.w),
            child: Row(
              // mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SmallUserInfo(
                  uid: pro.data.uid,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text(
                        pro.data.time,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 20.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Icon(Icons.tag),
                      Text(
                        "标签: " + pro.data.tag,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: themeColor2,
                          fontSize: 20.w,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: [
                      Text(
                        "赏金: " + pro.data.bill.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 25.w,
                        ),
                      ),
                      Icon(Icons.paid_rounded),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 20.w,
            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: themeColor))),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    return Container(
        width: double.maxFinite,
        margin: EdgeInsets.fromLTRB(60.w, 20.w, 60.w, 20.w),
        //color: Colors.red,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.all(20.w),
                    // height: 200.w,
                    //color: Colors.green,
                    child: Expanded(
                      child: Text(
                        pro.data.content,
                        style: TextStyle(fontSize: 25.w),
                        textAlign: TextAlign.left,
                        maxLines: 50,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(20.w),
                  child: Container(
                    width: 300.w,
                    height: 300.w,
                    child: proImg,
                  ),
                ),
              ],
            ),
            Container(
                width: double.maxFinite,
                //color: Colors.red,
                child: pro.data.confirmedAid.compareTo("0") == 0
                    ? Container()
                    : Column(
                        children: [
                          Container(
                            //height: 20.w,
                            margin: EdgeInsets.only(top: 10.w, bottom: 10.w),
                            decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: themeColor))),
                          ),
                          Container(
                            child: AnsCard(
                              aid: pro.data.confirmedAid,
                              method: () {
                                setState(() {});
                              },
                              userId: userId,
                              idx: -1,
                              conf: pro.data.confirmedAid,
                            ),
                          ),
                        ],
                      )),
            // Container(
            //     width: double.infinity,
            //     // color: Colors.red,
            //     child: pro.data.uid.compareTo(userId) != 0
            //         ? Container()
            //         : Align(
            //             alignment: Alignment.topLeft,
            //             child: IconButton(
            //               onPressed: () async {
            //                 await showDialog(
            //                   context: context,
            //                   builder: (context) {
            //                     return AlertDialog(
            //                       title: Text("提示", style: TextStyle(color: themeColor, fontSize: 22.w)),
            //                       content: Text(
            //                         "确认要删除该问题吗？",
            //                         textAlign: TextAlign.center,
            //                       ),
            //                       actions: <Widget>[
            //                         FlatButton(
            //                           onPressed: (() async {
            //                             var res = await NetRequestor.request(Apis.deletePro(pro.data.pid));
            //                             if (res['status'] == "10000") {
            //                               print("pro delete ok!");
            //                               //widget.method();
            //                             }
            //                             Navigator.of(context).pop();
            //                             Navigator.of(context).pop();
            //                           }),
            //                           child: Text("确认"),
            //                           color: themeColor2,
            //                           colorBrightness: Brightness.dark,
            //                           splashColor: themeColor,
            //                         ),
            //                         FlatButton(
            //                           onPressed: () => Navigator.of(context).pop(),
            //                           child: Text("取消"),
            //                           color: themeColor2,
            //                           colorBrightness: Brightness.dark,
            //                           splashColor: themeColor,
            //                         ),
            //                       ],
            //                     );
            //                   },
            //                 );
            //               },
            //               icon: Icon(Icons.delete_outline),
            //               iconSize: 30.w,
            //             ),
            //           )),
          ],
        ));
  }

  static String generateId() {
    return (10000000 + Random().nextInt(89999999)).toString();
  }

  Widget _comment() {
    return Container(
      width: double.maxFinite,
      height: 200.w,
      padding: EdgeInsets.fromLTRB(100.w, 50.w, 100.w, 20.w),
      // color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            //color: Colors.green,
            child: ClipOval(
              child: Image.network(usr.data.backgroundImg),
            ),
          ),
          Form(
            key: _formKey,
            child: Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20.w, right: 20.w),
                child: TextFormField(
                  controller: _cm,
                  cursorColor: themeColor2,
                  validator: (v) {
                    return ((v?.trim().length ?? 0) > 0) ? null : "回答不能为空";
                  },
                  decoration: InputDecoration(
                    hintText: "说说你的思路吧~",
                    hintStyle: TextStyle(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeColor,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: themeColor,
                        width: 2.0,
                      ),
                    ),
                  ),
                  maxLines: 5,
                ),
              ),
            ),
          ),
          Container(
            child: FlatButton(
              onPressed: () async {
                if ((_formKey.currentState as FormState).validate()) {
                  // print(DateTime.now().toString());
                  //print(_cm.text);
                  var res = await NetRequestor.request(Apis.publishAns(generateId(), _cm.text, pro.data.pid, userId));
                  if (res['status'] == "20000") {
                    print("发送失败");
                  } else {
                    _cm.text = "";
                    showAlertDialog(context, "发送成功");
                    _ansList.currentState?.init(pro.data.confirmedAid);
                  }
                }
              },
              color: themeColor,
              padding: EdgeInsets.all(50.w),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.w)),
              child: Text(
                "发表回答",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loadState == false) {
      dynamic para = (ModalRoute.of(context)?.settings.arguments);
      getPro(para[0], para[1]);
      return LoadingWidget();
    }
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: WebBar(),
            flex: 1,
          ),
          Expanded(
            child: Container(
              color: themeColor,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 50.w, bottom: 20.w, left: 200.w, right: 200.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      child: Column(
                        children: <Widget>[
                          _title(),
                          _usr(),
                          _content(),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50.w, bottom: 20.w, left: 200.w, right: 200.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      child: Column(
                        children: <Widget>[
                          _comment(),
                          AnsList(key: _ansList, pid: pro.data.pid, uid: userId, conf: pro.data.confirmedAid),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            flex: 9,
          ),
        ],
      ),
    );
  }
}

class AnsList extends StatefulWidget {
  final String pid;
  final String conf;
  final uid;
  const AnsList({Key? key, required this.pid, required this.uid, required this.conf}) : super(key: key);

  @override
  _AnsListState createState() => _AnsListState(pid);
}

class _AnsListState extends State<AnsList> {
  bool _loadState = false;
  String pid;
  _AnsListState(this.pid);
  List<String> aids = [];
  Answer ans = new Answer();

  @override
  void initState() {
    super.initState();
    init(widget.conf);
  }

  void init(String ch) {
    aids.clear();
    NetRequestor.request(Apis.getAllAns(pid)).then((value) {
      var data = value['data'];
      aids = (data as List<dynamic>).cast<String>();
      aids.remove(ch);
      setState(() {
        _loadState = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                width: double.maxFinite,
                child: Container(
                    margin: EdgeInsets.all(10.w),
                    child: Row(
                      children: [
                        Text("${aids.length} 回答"),
                        IconButton(
                            onPressed: () {
                              setState(() {
                                init(widget.conf);
                              });
                            },
                            icon: Icon(Icons.replay)),
                      ],
                    )),
                //height: 20.w,
                decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: themeColor))),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: aids.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                      //height: 250.w,
                      padding: EdgeInsets.all(10.w),
                      margin: EdgeInsets.only(top: 10.w, bottom: 10.w, right: 30.w, left: 50.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.w),
                      ),
                      child: Column(
                        children: [
                          AnsCard(
                            aid: aids[index],
                            idx: index,
                            method: init,
                            userId: widget.uid,
                            conf: widget.conf,
                          ),
                        ],
                      ));
                },
              ),
            ],
          );
  }
}
