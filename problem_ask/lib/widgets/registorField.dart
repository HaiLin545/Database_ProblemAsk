import 'dart:async';
import 'dart:math';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/alertDialog.dart';

class RegistorField extends StatefulWidget {
  const RegistorField({Key? key}) : super(key: key);

  @override
  _RegistorFieldState createState() => _RegistorFieldState();
}

class _RegistorFieldState extends State<RegistorField> {
  TextEditingController _user = TextEditingController();
  TextEditingController _pwd = TextEditingController();
  TextEditingController _code = TextEditingController();
  GlobalKey _formKey1 = new GlobalKey<FormState>();
  GlobalKey _formKey2 = new GlobalKey<FormState>();
  bool passwordVisible = false;

  bool isButtonEnable = true; //按钮状态  是否可点击
  String buttonText = '发送验证码'; //初始文本
  int count = 60; //初始倒计时时间
  late Timer timer; //倒计时的计时器

  void _buttonClickListen() {
    setState(() {
      if (isButtonEnable) {
        isButtonEnable = false;
        _initTimer();
        _sentEmail();
        return null;
      } else {
        return null;
      }
    });
  }

  void _initTimer() {
    timer = new Timer.periodic(Duration(seconds: 1), (Timer timer) {
      count--;
      setState(() {
        if (count == 0) {
          timer.cancel(); //倒计时结束取消定时器
          isButtonEnable = true; //按钮可点击
          count = 60; //重置时间
          buttonText = '发送验证码'; //重置按钮文本
        } else {
          buttonText = '重新发送($count)'; //更新文本内容
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  @override
  void dispose() {
    _user.dispose();
    _pwd.dispose();
    timer.cancel(); //销毁计时器
    _code.dispose();
    super.dispose();
  }

  /// 邮箱正则
  final String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";

  /// 检查是否是邮箱格式
  bool isEmail(String input) {
    if (input.isEmpty) return false;
    return new RegExp(regexEmail).hasMatch(input);
  }

  Widget _userText() {
    return TextFormField(
      controller: _user,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "使用邮箱注册",
      ),
      autofocus: false,
      validator: (v) {
        return isEmail(v.toString()) ? null : "请输入正确的邮箱!";
      },
    );
  }

  Widget _pwdText() {
    return TextFormField(
      controller: _pwd,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock),
        hintText: "密码",
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
          icon: Icon(
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Theme.of(context).primaryColorDark,
          ),
        ),
      ),
      autofocus: false,
      obscureText: !passwordVisible,
      validator: (v) {
        return ((v?.trim().length ?? 0) >= 5) ? null : "密码不能小于5位";
      },
    );
  }

  Widget _codeVerify() {
    return TextFormField(
      controller: _code,
      decoration: InputDecoration(
        // prefixIcon: Icon(Icons.lock),
        hintText: "验证码",
        suffixIcon: TextButton(
          onPressed: () {
            if ((_formKey1.currentState as FormState).validate()) _buttonClickListen();
          },
          child: Text(
            buttonText,
            style: TextStyle(color: themeColor2),
          ),
        ),
      ),
      autofocus: false,
    );
  }

  Widget _tips() {
    return Container(
      padding: EdgeInsets.all(10.w),
      decoration: BoxDecoration(
          // color: Colors.blue,
          ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          child: FlatButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("去登陆"),
          ),
        ),
      ),
    );
  }

  Widget _registorButton() {
    return Container(
      margin: EdgeInsets.only(top: 30.w, bottom: 10.w),
      child: RaisedButton(
        child: Text(
          "注册",
          style: TextStyle(fontSize: 20.w),
        ),
        color: themeColor2,
        colorBrightness: Brightness.dark,
        splashColor: themeColor,
        padding: EdgeInsets.only(left: 100.w, right: 100.w, top: 10.w, bottom: 15.w),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        onPressed: () async {
          if ((_formKey1.currentState as FormState).validate() && (_formKey2.currentState as FormState).validate()) {
            var uid = generateId();
            print(uid);
            var result = await NetRequestor.request(Apis.registor(_user.text, _pwd.text, uid, _code.text));
            print(_code.text);
            var status = result['status'];
            if (status == "30000") {
              showAlertDialog(context, "用户已存在！");
            } else if (status == "40000") {
              showAlertDialog(context, "验证码错误！");
            } else if (status == "20000") {
              showAlertDialog(context, "cookie！");
            } else {
              showAlertDialog(context, "注册成功！");
              Navigator.pop(context);
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Form(
            key: _formKey1,
            child: Flex(
              direction: Axis.vertical,
              children: [
                _userText(),
                _pwdText(),
              ],
            ),
          ),
          Form(
            key: _formKey2,
            child: Flex(
              direction: Axis.vertical,
              children: [
                _codeVerify(),
                _registorButton(),
              ],
            ),
          ),
          _tips(),
        ],
      ),
    );
  }

  static String generateId() {
    return (10000000 + Random().nextInt(89999999)).toString();
  }

  void _sentEmail() {
    NetRequestor.request(Apis.sendEmail(_user.text));
  }
}
