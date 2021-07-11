import 'package:flutter/material.dart';
import 'package:problem_ask/widgets/AnsCard.dart';
import 'package:problem_ask/data/ans.dart';
import 'package:problem_ask/config/config.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/net/apis.dart';

class AnsList extends StatefulWidget {
  final String pid;
  const AnsList({Key? key, required this.pid}) : super(key: key);

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
    init();
  }

  void init() async {
    NetRequestor.request(Apis.getAllAns(pid)).then((value) {
      var data = value['data'];
      aids.clear();
      aids = (data as List<dynamic>).cast<String>();
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
                                init();
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
                    child: AnsCard(
                      aid: aids[index],
                      idx: index,
                      method: init,
                      userId: "",
                      conf: "0",
                    ),
                  );
                },
              ),
            ],
          );
  }
}
