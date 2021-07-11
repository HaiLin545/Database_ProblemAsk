import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/alertDialog.dart';
import 'package:image_picker_web/image_picker_web.dart';
import 'package:problem_ask/widgets/loading.dart';
import 'package:problem_ask/widgets/webBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:html' as html;
import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/painting.dart'; // NetworkImage

class NewProblemPage extends StatefulWidget {
  NewProblemPage({Key? key}) : super(key: key);
  @override
  _NewProblemPageState createState() => _NewProblemPageState();
}

class _NewProblemPageState extends State<NewProblemPage> {
  String uid = "";
  bool _loadState = false;
  List img = [];
  GlobalKey _formKey = GlobalKey<FormState>();
  GlobalKey<_ImgGridState> _imgKey = GlobalKey<_ImgGridState>();
  TextEditingController _title = TextEditingController();
  TextEditingController _content = TextEditingController();
  TextEditingController _bill = TextEditingController();
  TextEditingController _tag = TextEditingController();

  User user = new User();

  void init(String _uid) {
    NetRequestor.request(Apis.getUserInfo(_uid)).then((v) {
      if (v != null) {
        uid = _uid;
        user = User.fromJson(v);
        setState(() {
          _loadState = true;
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _title.dispose();
    _content.dispose();
    _tag.dispose();
  }

  List<int> _selectedFile = [];
  late Uint8List _bytesData;

  void _handleResult(Object result) {
    setState(() {
      _bytesData = Base64Decoder().convert(result.toString().split(",").last);
      _imgKey.currentState?.addImg(_bytesData);
      _selectedFile = _bytesData;
    });
  }

  startWebFilePicker() async {
    // var imgFile =  ImagePickerWeb.getImage(outputType: ImageType.widget);
    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
    uploadInput.multiple = true;
    uploadInput.draggable = true;
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;
      final file = files![0];
      final reader = new html.FileReader();
      reader.onLoadEnd.listen((e) {
        _handleResult(reader.result!);
      });
      reader.readAsDataUrl(file);
      img.add(file);
    });
  }

  static String generateId() {
    return (10000000 + Random().nextInt(89999999)).toString();
  }

  makeRequest() async {
    http.MultipartFile multipartFile = http.MultipartFile.fromBytes(
      'image',
      _selectedFile,
      contentType: new MediaType('application', 'octet-stream'),
      filename: "${DateTime.now()}.png",
    );
    var uri = Uri.parse(serverUrl + Apis.publishPro());
    var request = new http.MultipartRequest("POST", uri);
    request.fields['pid'] = "11111111";
    request.fields['uid'] = uid;
    request.fields['content'] = _content.text;
    request.fields['title'] = _title.text;
    request.fields['tag'] = _tag.text;
    request.fields['bill'] = _bill.text;
    request.files.add(multipartFile);
    var response = await request.send();
    //Map _body = jsonDecode((await http.Response.fromStream(response)).body);
    if (response.statusCode == 200) print('Uploaded!');
    //  print(_body['status']);
  }

  @override
  Widget build(BuildContext context) {
    // _content.text =
    //     "国家网信办消息，根据举报，经检测核实，“滴滴企业版”等25款App存在严重违法违规收集使用个人信息问题。国家互联网信息办公室依据《中华人民共和国网络安全法》相关规定，通知应用商店下架上述25款App，要求相关运营者严格按照法律要求，参照国家有关标准，认真整改存在的问题，切实保障广大用户个人信息安全。各网站、平台不得为“滴滴出行”和“滴滴企业版”等上述25款已在应用商店下架的App提供访问和下载服务。";
    // _title.text = "如何看待网信办通报下架「滴滴企业版」等 25 款 App？";
    // //_bill.text = "";
    // _tag.text = "社会";
    if (!_loadState) init((ModalRoute.of(context)?.settings.arguments).toString());
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
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: themeColor,
                      ),
                      child: Container(
                        margin: EdgeInsets.only(top: 50.w, bottom: 50.w, left: 100.w, right: 100.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30.w),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                margin: EdgeInsets.all(20.w),
                                // color: Colors.red,
                                // width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "发布题目",
                                    style: TextStyle(
                                      color: themeColor,
                                      fontSize: 30.w,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                // color: themeColor2,
                                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 20.w),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.w),
                                      child: Text(
                                        "题目标题：",
                                        style: TextStyle(
                                          fontSize: 25.w,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _title,
                                        validator: (v) {
                                          return v!.length == 0 ? "题目标题不能为空" : null;
                                        },
                                        style: TextStyle(fontSize: 20.w),
                                        decoration: InputDecoration(
                                          hintText: "输入题目标题",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.w),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 20.w),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 10.w),
                                      child: Text(
                                        "题目内容：",
                                        style: TextStyle(
                                          fontSize: 25.w,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextFormField(
                                        controller: _content,
                                        validator: (v) {
                                          return v!.length == 0 ? "题目内容不能为空" : null;
                                        },
                                        maxLines: 5,
                                        style: TextStyle(fontSize: 20.w),
                                        decoration: InputDecoration(
                                          hintText: "输入题目内容",
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(20.w),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 20.w),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      child: Text(
                                        "添加图片：",
                                        style: TextStyle(
                                          fontSize: 25.w,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 200.w,
                                      height: 200.w,
                                      color: Colors.grey[100],
                                      child: IconButton(
                                        icon: Icon(Icons.add),
                                        onPressed: startWebFilePicker,
                                      ),
                                    ),
                                    ImgGrid(
                                      key: _imgKey,
                                      img: img,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 30.w),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      child: Text(
                                        "添加题目标签：",
                                        style: TextStyle(
                                          fontSize: 25.w,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300.w,
                                      child: Expanded(
                                        child: TextFormField(
                                          controller: _tag,
                                          style: TextStyle(fontSize: 20.w),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "输入标签，如English",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.w),
                                            ),
                                          ),
                                          validator: (v) {
                                            return (v!.length > 0) ? null : "请输入标签！";
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 50.w, left: 50.w, top: 30.w),
                                child: Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      child: Text(
                                        "设置赏金：",
                                        style: TextStyle(
                                          fontSize: 25.w,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 300.w,
                                      child: Expanded(
                                        child: TextFormField(
                                          controller: _bill,
                                          style: TextStyle(fontSize: 20.w),
                                          keyboardType: TextInputType.number,
                                          decoration: InputDecoration(
                                            hintText: "输入赏金数额",
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20.w),
                                            ),
                                          ),
                                          validator: (v) {
                                            if (v?.length == 0) return "请输入赏金数!";
                                            int xx = min((user.data.level + 1) * 100, user.data.bill);
                                            return int.parse(v!) <= xx ? null : "设置赏金数不能大于$xx!";
                                          },
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20.w),
                                      child: Text(
                                        " (你拥有的问币数: ${user.data.bill.toString()} ) ",
                                        style: TextStyle(
                                          fontSize: 20.w,
                                          color: themeColor,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(50.w),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FlatButton(
                                      child: Text(
                                        "发布",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.w,
                                        ),
                                      ),
                                      onPressed: () {
                                        if ((_formKey.currentState as FormState).validate()) {
                                          makeRequest();
                                          // makeRequest();
                                          showAlertDialog(this.context, "发布成功！");
                                        }
                                      },
                                      padding: EdgeInsets.only(top: 20.w, bottom: 20.w, right: 40.w, left: 40.w),
                                      textColor: themeColor,
                                      color: themeColor2,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.w)),
                                    ),
                                    FlatButton(
                                      child: Text(
                                        "返回",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 30.w,
                                        ),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop("refresh");
                                      },
                                      padding: EdgeInsets.only(top: 20.w, bottom: 20.w, right: 40.w, left: 40.w),
                                      textColor: themeColor,
                                      color: themeColor2,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.w)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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

class ImgGrid extends StatefulWidget {
  final List img = [];
  ImgGrid({Key? key, required img}) : super(key: key);

  @override
  _ImgGridState createState() => _ImgGridState(img: img);
}

class _ImgGridState extends State<ImgGrid> {
  List img = [];
  _ImgGridState({required this.img});

  void addImg(var image) {
    setState(() {
      img.add(image);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 200.w,
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: img.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 200.w,
                    width: 200.w,
                    margin: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(30.w),
                    ),
                    child: Container(
                      child: Image.memory(img[index], fit: BoxFit.fill),
                      // Image.network(
                      //   img[index],
                      //   fit: BoxFit.fill,
                      // ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
