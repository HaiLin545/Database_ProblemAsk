import 'dart:html';

import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/proCard.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SelectedProblem extends StatefulWidget {
  final String usrId;
  const SelectedProblem({Key? key, required this.usrId}) : super(key: key);
  @override
  _SelectedProblemState createState() => _SelectedProblemState(usrId);
}

class _SelectedProblemState extends State<SelectedProblem> {
  _SelectedProblemState(this.userId);
  String userId;
  GlobalKey _formKey = new GlobalKey<FormState>();
  GlobalKey<_ProblemListState> _problemListKey = GlobalKey<_ProblemListState>();
  TextEditingController _search = new TextEditingController();
  String _searchContent = "";
  String _sortType = "default";
  String newSortType = "default";
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      //color: themeColor,
      key: _formKey,
      child: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: Container(
              child: Container(
                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 10.w, bottom: 10.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.w),
                  color: Colors.white,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 30.w, right: 30.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: DropdownButton(
                          value: "default",
                          hint: Text("默认排序"),
                          items: [
                            DropdownMenuItem(
                              child: Text("收藏量"),
                              value: "like",
                            ),
                            DropdownMenuItem(
                              child: Text("最新发布"),
                              value: "new",
                            ),
                            DropdownMenuItem(
                              child: Text("默认排序"),
                              value: "default",
                            ),
                          ],
                          onChanged: (value) {
                            newSortType = value.toString();
                            if (newSortType != _sortType) {
                              _sortType = newSortType;
                              sortAction();
                            }
                          },
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 30.w, right: 30.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Container(
                          child: TextFormField(
                            //  autovalidate: true,
                            controller: _search,
                            maxLines: 1,
                            cursorColor: themeColor2,
                            onEditingComplete: () {
                              searchAction();
                              // showAlertDialog(context, "?");
                            },
                            decoration: InputDecoration(
                              hintText: "输入你想搜索的问题",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.w),
                                borderSide: BorderSide(
                                  color: themeColor,
                                  width: 2.0,
                                ),
                              ),
                              prefixIcon: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  searchAction();
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      flex: 4,
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(Icons.replay),
                        onPressed: () {
                          searchAction();
                        },
                      ),
                      flex: 1,
                    )
                  ],
                ),
              ),
            ),
            flex: 1,
          ),
          Expanded(
            child: ProblemList(
              key: _problemListKey,
              sortType: _sortType,
              searchContent: _searchContent,
              userId: userId,
            ),
            flex: 7,
          ),
        ],
      ),
    );
  }

  void searchAction() {
    if ((_formKey.currentState as FormState).validate()) {
      //  print(_search.text);
      _problemListKey.currentState?.onStateChanged(_sortType, _search.text);
    }
  }

  void sortAction() {
    _problemListKey.currentState?.onStateChanged(_sortType, _search.text);
  }
}

class ProblemList extends StatefulWidget {
  final String searchContent;
  final String userId;
  final String sortType;
  const ProblemList({Key? key, required this.searchContent, required this.sortType, required this.userId})
      : super(key: key);

  @override
  _ProblemListState createState() =>
      _ProblemListState(sortType: sortType, searchContent: searchContent, userId: userId);
}

class _ProblemListState extends State<ProblemList> {
  late List<String> pids;
  bool _loadState = false;
  String searchContent;
  String sortType = "default";
  String userId;
  _ProblemListState({required this.sortType, required this.searchContent, required this.userId});
  @override
  void initState() {
    super.initState();
    late String url;
    if (searchContent == "") {
      url = Apis.getpids();
    } else
      url = Apis.proSearch(searchContent);
    NetRequestor.request(Apis.getpids()).then((value) {
      var data = value['data'];
      pids = (data as List<dynamic>).cast<String>();
      setState(() {
        _loadState = true;
      });
    });
  }

  void onStateChanged(String sortType, String t) {
    setState(() {
      sortType = sortType;
      searchContent = t;
      _loadState = false;
      late String url;
      if (searchContent == "") {
        url = Apis.getpids();
      } else {
        url = Apis.proSearch(searchContent);
      }

      NetRequestor.request(url).then((value) {
        var data = value['data'];
        pids = (data as List<dynamic>).cast<String>();
        setState(() {
          _loadState = true;
        });
      });
    });
    // print(userId);
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            padding: EdgeInsets.only(top: 40.w),
            child: Expanded(
              // flex: 1,
              child: pids.length == 0
                  ? Text(
                      "找不到相关的问题噢~(～￣▽￣)～",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.w,
                      ),
                    )
                  : ListView.builder(
                      itemCount: pids.length,
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
