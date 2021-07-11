import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/ans.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/alertDialog.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnsCard extends StatefulWidget {
  final String aid;
  final int idx;
  final method;
  final userId;
  final String conf;
  const AnsCard(
      {Key? key, required this.idx, required this.aid, required this.method, required this.userId, required this.conf})
      : super(key: key);

  @override
  _AnsCardState createState() => _AnsCardState(aid, idx);
}

class _AnsCardState extends State<AnsCard> {
  String aid;
  int idx;
  _AnsCardState(
    this.aid,
    this.idx,
  );
  Answer ans = new Answer();
  User usr = new User();
  bool _loadState = false;

  @override
  void initState() {
    super.initState();
    //   print(idx.toString() + "??" + widget.conf);
    NetRequestor.request(Apis.getAns(aid)).then((value) {
      if (value != null) {
        ans = Answer.fromJson(value);
        // print(ans.data.content);
        NetRequestor.request(Apis.getUserInfo(ans.data.uid)).then((v) {
          if (v != null) {
            usr = User.fromJson(v);
            //  print(aid + " " + idx.toString() + " " + widget.userId + " " + ans.data.uid);
            setState(() {
              _loadState = true;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(20.w, 0.w, 20.w, 0.w),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: 150.w,
                    width: 150.w,
                    margin: EdgeInsets.all(20.w),
                    child: ClipOval(
                      child: Image.network(usr.data.backgroundImg),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
                            //  color: Colors.red,
                            width: double.maxFinite,
                            child: Row(
                              children: [
                                Text(
                                  usr.data.name,
                                  style: TextStyle(color: themeColor, fontWeight: FontWeight.bold, fontSize: 20.w),
                                ),
                                Text(
                                  "  LV" + usr.data.level.toString(),
                                  style: TextStyle(color: themeColor2),
                                ),
                                Expanded(
                                  //width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: idx == -1
                                        ? Text(
                                            "正解",
                                            style: TextStyle(color: themeColor, fontSize: 30.w),
                                          )
                                        : Text(
                                            (idx + 1).toString(),
                                            style: TextStyle(color: themeColor),
                                          ),
                                  ),
                                )
                              ],
                            )),
                        Container(
                          margin: EdgeInsets.all(10.w),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                child: Text(
                                  ans.data.content,
                                  maxLines: 10,
                                  style: TextStyle(fontSize: 20.w),
                                  textAlign: TextAlign.left,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                // margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                child: widget.conf != "0"
                                    ? Container()
                                    : TextButton(
                                        child: Text("设为正解", style: TextStyle(color: themeColor2, fontSize: 20.w)),
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("提示", style: TextStyle(color: themeColor, fontSize: 22.w)),
                                                content: Text(
                                                  "确认要设置该回答为正解吗？",
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: (() async {
                                                      var res = await NetRequestor.request(Apis.getConfirmed(aid));
                                                      if (res['status'] == "10000") {
                                                        print(aid + "getConfirmed ok!");
                                                        widget.method(aid);
                                                      }
                                                      Navigator.of(context).pop();
                                                    }),
                                                    child: Text("确认"),
                                                    color: themeColor2,
                                                    colorBrightness: Brightness.dark,
                                                    splashColor: themeColor,
                                                  ),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text("取消"),
                                                    color: themeColor2,
                                                    colorBrightness: Brightness.dark,
                                                    splashColor: themeColor,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                              ),
                              Text(
                                ans.data.time,
                                style: TextStyle(color: themeColor),
                              ),
                              Container(
                                child: ans.data.uid.compareTo(widget.userId) != 0 || widget.idx == -1
                                    ? Container(
                                        width: 20.w,
                                      )
                                    : IconButton(
                                        onPressed: () async {
                                          await showDialog(
                                            context: context,
                                            builder: (context) {
                                              return AlertDialog(
                                                title: Text("提示", style: TextStyle(color: themeColor, fontSize: 22.w)),
                                                content: Text(
                                                  "确认要删除该条回答吗？",
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: (() async {
                                                      var res = await NetRequestor.request(Apis.deleteAns(aid));
                                                      if (res['status'] == "10000") {
                                                        print("ans delete ok!");
                                                        widget.method("");
                                                      }
                                                      Navigator.of(context).pop();
                                                    }),
                                                    child: Text("确认"),
                                                    color: themeColor2,
                                                    colorBrightness: Brightness.dark,
                                                    splashColor: themeColor,
                                                  ),
                                                  FlatButton(
                                                    onPressed: () => Navigator.of(context).pop(),
                                                    child: Text("取消"),
                                                    color: themeColor2,
                                                    colorBrightness: Brightness.dark,
                                                    splashColor: themeColor,
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        icon: Icon(Icons.delete_outline),
                                        iconSize: 25.w,
                                      ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(20.w, 10.w, 20.w, 10.w),
                          width: double.maxFinite,
                          decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 2, color: themeColor))),
                        ),
                      ],
                    ),
                  ),
                  flex: 7,
                ),
              ],
            ),
          );
  }
}
