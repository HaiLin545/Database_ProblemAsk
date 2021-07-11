import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/problems.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/smallUserInfo.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProCard extends StatefulWidget {
  final String pid;
  final String userId;
  const ProCard({Key? key, required this.pid, required this.userId}) : super(key: key);

  @override
  _ProCardState createState() => _ProCardState(pid, userId);
}

class _ProCardState extends State<ProCard> {
  String pid;
  String userId;
  _ProCardState(this.pid, this.userId);

  Problem pro = new Problem();
  bool _loadState = false;

  @override
  void initState() {
    super.initState();
    try {
      NetRequestor.request(Apis.getProblem(pid)).then((value) {
        if (value != null) {
          pro = Problem.fromJson(value);
        }
        if (mounted) {
          setState(() {
            _loadState = true;
          });
        }
      });
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            child: Column(
              children: <Widget>[
                Expanded(
                  flex: 3,
                  child: MaterialButton(
                    onPressed: () {
                      List arg = [pid, userId];
                      SharedPreferences.getInstance().then((value) {
                        value.setString('pid', pid);
                        //print(user.data.uid);
                      });
                      Navigator.of(context).pushNamed("problem", arguments: arg);
                    },
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.all(20.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Expanded(
                                      child: Text(
                                        pro.data.title,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30.w),
                                      ),
                                    ),
                                  ),
                                  flex: 7,
                                ),
                                Expanded(
                                  child: Align(
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
                                  flex: 2,
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
                                            fontSize: 25.w,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  flex: 1,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                pro.data.content,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(fontWeight: FontWeight.normal),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    onPressed: () {
                      List arg = [pid, userId];
                      Navigator.of(context).pushNamed("problem", arguments: arg);
                    },
                    child: Container(
                      // color: Colors.red,
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
                  ),
                )
              ],
            ),
          );
  }
}
