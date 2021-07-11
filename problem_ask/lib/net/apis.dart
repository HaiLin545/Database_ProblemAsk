import 'dart:io';
import 'package:problem_ask/net/netRequest.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

class Apis {
  //登录
  static String login(String email, String pwd) {
    return "/user/login?email=$email&password=$pwd";
  }

  //注册
  static String registor(String email, String pwd, String uid, String code) {
    return "/user/addUser?email=$email&password=$pwd&uid=$uid&code=$code";
  }

  //更新
  static String updateInfo(String uid, String name, String gender, String birth, String city) {
    return "/user/updateInfo?uid=$uid&name=$name&gender=$gender&birth=$birth&city=$city";
  }

  //验证码
  static String sendEmail(String email) {
    return "/user/sendEmail?email=$email";
  }

  //获取用户信息
  static String getUserInfo(uid) {
    return "/user/queryInfo?uid=$uid";
  }

  //获取一个问题
  static String getProblem(String pid) {
    return "/pro/query?pid=$pid";
  }

//获取一个图片
  static String getPic(String url) {
    return "/showPic?url=$url";
  }

  //删除问题
  static String deletePro(String pid) {
    return "/pro/delete?pid=$pid";
  }

  //获取用户所有问题
  static String getUserAllProblems(String uid) {
    return "/pro/queryUserAll?uid=$uid";
  }

  //获取所有问题
  static String getpids() {
    return "/pro/queryAll";
  }

  // 模糊搜索
  static String proSearch(String pattern) {
    return "/pro/search?pattern=$pattern";
  }

  //获取用户关注的问题
  static String getFollow(String uid) {
    return "/pro/getFollow?uid=$uid";
  }

  //获取用户回答过的问题
  static String getAnswered(String uid) {
    return "/pro/getAnswered?uid=$uid";
  }

  // 发布题目
  static String publishPro() {
    return "/pro/publish";
  }

  // 获取回答
  static String getAns(String aid) {
    return "/answer/query?aid=$aid";
  }
  // 设置正解

  static String getConfirmed(String aid) {
    return "/answer/getConfirmed?aid=$aid";
  }

  // 关注题目
  static String follow(String pid, String uid) {
    return "/follow?pid=$pid&uid=$uid";
  }

  // 判断是否关注了题目
  static String isFollow(String pid, String uid) {
    return "/getFollow?pid=$pid&uid=$uid";
  }

  // 取消关注题目
  static String unfollow(String pid, String uid) {
    return "/unfollow?pid=$pid&uid=$uid";
  }

  //删除回答
  static String deleteAns(String aid) {
    return "/answer/delete?aid=$aid";
  }

  // 获取问题下所有回答
  static String getAllAns(String pid) {
    return "/answer/getProAns?pid=$pid";
  }

  //发布回答
  static String publishAns(String aid, String content, String pid, String uid) {
    return "/answer/write?aid=$aid&content=$content&pid=$pid&uid=$uid";
  }
}
