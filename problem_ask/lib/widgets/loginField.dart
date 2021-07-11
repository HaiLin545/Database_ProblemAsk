import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:problem_ask/config/config.dart';
import 'package:problem_ask/data/user.dart';
import 'package:problem_ask/net/apis.dart';
import 'package:problem_ask/net/netRequest.dart';
import 'package:problem_ask/widgets/alertDialog.dart';

class LoginField extends StatefulWidget {
  const LoginField({Key? key}) : super(key: key);

  @override
  _LoginFieldState createState() => _LoginFieldState();
}

class _LoginFieldState extends State<LoginField> {
  TextEditingController _user = TextEditingController();
  TextEditingController _pwd = TextEditingController();
  GlobalKey _formKey = new GlobalKey<FormState>();
  late String email;
  late String pwd;
  late bool passwordVisible;
  @override
  void initState() {
    super.initState();
    passwordVisible = false;
  }

  Widget _userText() {
    return TextFormField(
      controller: _user,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.person),
        hintText: "邮箱",
      ),
      autofocus: false,
      validator: (v) {
        return ((v?.trim().length ?? 0) > 0) ? null : "邮箱不能为空";
      },
    );
  }

  Widget _pwdText() {
    return TextFormField(
      controller: _pwd,
      obscureText: !passwordVisible,
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
      validator: (v) {
        return ((v?.trim().length ?? 0) > 5) ? null : "密码不能小于5位";
      },
    );
  }

  Widget _tips() {
    return Container(
      padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.w, bottom: 20.w),
      decoration: BoxDecoration(
          // color: Colors.blue,
          ),
      child: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              child: FlatButton(
                onPressed: () {},
                child: Text("忘记密码?"),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("registor");
                },
                child: Text("去注册"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
    return RaisedButton(
      child: Text(
        "登录",
        style: TextStyle(fontSize: 20.w),
      ),
      color: themeColor2,
      colorBrightness: Brightness.dark,
      splashColor: themeColor,
      padding: EdgeInsets.only(left: 100.w, right: 100.w, top: 10.w, bottom: 15.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
      onPressed: () async {
        email = _user.text;
        pwd = _pwd.text;
        if ((_formKey.currentState as FormState).validate()) {
          var result = await NetRequestor.request(Apis.login(email, pwd));

          if (result['status'] == "20000")
            showAlertDialog(context, "账号或密码错误");
          else {
            //final prefs = await
            User user = User.fromJson(result);
            SharedPreferences.getInstance().then((value) {
              value.setString('uid', user.data.uid);
              //  print(user.data.uid);
            });
            Navigator.of(context).pushNamed("home", arguments: user.data.uid);
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          _userText(),
          _pwdText(),
          _tips(),
          _loginButton(),
        ],
      ),
    );
  }
}
