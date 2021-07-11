import 'package:flutter/material.dart';
import 'package:problem_ask/widgets/proCard.dart';
import 'package:problem_ask/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/net/apis.dart';

class ProblemList extends StatefulWidget {
  final String? type;
  final String userId;
  const ProblemList({Key? key, this.type, required this.userId}) : super(key: key);

  @override
  _ProblemListState createState() => _ProblemListState(type: type, userId: userId);
}

class _ProblemListState extends State<ProblemList> {
  late List<String> pids;
  bool _loadState = false;
  String? type;
  String userId;
  _ProblemListState({this.type, required this.userId});
  @override
  void initState() {
    super.initState();
    NetRequestor.request(Apis.getpids()).then((value) {
      var data = value['data'];
      pids = (data as List<dynamic>).cast<String>();
      setState(() {
        _loadState = true;
      });
    });
  }

  void onStateChanged(String t) {
    type = t;
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            padding: EdgeInsets.only(top: 40.w),
            child: Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: type?.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 250.w,
                    padding: EdgeInsets.all(10.w),
                    margin: EdgeInsets.only(top: 10.w, bottom: 10.w, right: 30.w, left: 50.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.w),
                    ),
                    child: ProCard(userId: userId, pid: pids[index]),
                  );
                },
              ),
            ),
          );
  }
}
