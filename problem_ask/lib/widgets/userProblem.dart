import 'package:flutter/material.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/proCard.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class UserProblem extends StatefulWidget {
  final String tag;
  final String userId;
  const UserProblem({Key? key, required this.userId, required this.tag}) : super(key: key);
  @override
  _UserProblemState createState() => _UserProblemState(tag, userId);
}

class _UserProblemState extends State<UserProblem> {
  _UserProblemState(this.tag, this.userId);
  GlobalKey _formKey = new GlobalKey<FormState>();
  GlobalKey<_ProblemListState> _problemListKey = GlobalKey<_ProblemListState>();
  TextEditingController _search = new TextEditingController();
  String _searchContent = "";
  String _sortType = "default";
  String newSortType = "default";
  String tag;
  String userId;
  bool _loadState = true;
  @override
  void initState() {
    super.initState();
  }

  void setTag(String newTag) {
    if (tag != newTag) {
      setState(() {
        tag = newTag;
        //print("newTag" + newTag);
        _problemListKey.currentState!.onStateChanged(tag, _sortType, _searchContent);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Form(
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
                      child: Container(
                        margin: EdgeInsets.only(right: 20.w, left: 20.w),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: tag == "1" ? Colors.grey : Colors.white,
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setTag("1");
                                },
                                child: Text(
                                  "发布的题目",
                                  style: TextStyle(
                                    fontSize: 25.w,
                                    color: themeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: tag == "2" ? Colors.grey : Colors.white,
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setTag("2");
                                },
                                child: Text(
                                  "回答的题目",
                                  style: TextStyle(
                                    fontSize: 25.w,
                                    color: themeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.w),
                              decoration: BoxDecoration(
                                color: tag == "3" ? Colors.grey : Colors.white,
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: TextButton(
                                onPressed: () {
                                  setTag("3");
                                },
                                child: Text(
                                  "收藏的题目",
                                  style: TextStyle(
                                    fontSize: 25.w,
                                    color: themeColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: ProblemList(
                    userId: userId,
                    key: _problemListKey,
                    searchContent: _searchContent,
                    sortType: _sortType,
                    tag: tag,
                  ),
                  flex: 7,
                ),
              ],
            ),
          );
  }

  void searchAction() {
    if ((_formKey.currentState as FormState).validate())
      _problemListKey.currentState?.onStateChanged("1", _sortType, _search.text);
  }

  void sortAction() {
    _problemListKey.currentState?.onStateChanged("1", _sortType, _sortType);
  }
}

class ProblemList extends StatefulWidget {
  final String searchContent;
  final String userId;
  final String sortType;
  final String tag;
  const ProblemList(
      {Key? key, required this.tag, required this.searchContent, required this.sortType, required this.userId})
      : super(key: key);

  @override
  _ProblemListState createState() =>
      _ProblemListState(sortType: sortType, searchContent: searchContent, userId: userId, tag: tag);
}

class _ProblemListState extends State<ProblemList> {
  List<String> pids = [];
  bool _loadState = false;
  String searchContent;
  String sortType = "default";
  String tag;
  String userId;
  _ProblemListState({required this.sortType, required this.searchContent, required this.userId, required this.tag});

  String getUrl(String _tag) {
    if (_tag.compareTo("1") == 0)
      return Apis.getUserAllProblems(userId);
    else if (_tag.compareTo("2") == 0)
      return Apis.getAnswered(userId);
    else
      return Apis.getFollow(userId);
  }

  @override
  void initState() {
    super.initState();
    pids.clear();
    NetRequestor.request(getUrl(tag)).then((value) {
      var data = value['data'];
      pids = (data as List<dynamic>).cast<String>();
      setState(() {
        _loadState = true;
      });
    });
  }

  void onStateChanged(String newTag, String newSortType, String newSearchContent) {
    setState(() {
      _loadState = false;
    });
    pids.clear();
    NetRequestor.request(getUrl(newTag)).then((value) {
      var data = value['data'];
      pids = (data as List<dynamic>).cast<String>();
      //  print("new" + newTag + " " + newSortType + " " + newSearchContent);
      setState(() {
        tag = newTag;
        _loadState = true;
        // print(pids.length);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _loadState == false
        ? LoadingWidget()
        : Container(
            padding: EdgeInsets.only(top: 20.w),
            child: Expanded(
              // flex: 1,
              child: ListView.builder(
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
