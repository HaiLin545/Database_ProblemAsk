class User {
  late String status;
  late Data data;

  User({String s = "Not found!"}) {
    this.status = s;
    this.data = new Data();
  }

  User.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = new Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data.toJson();
    return data;
  }
}

class Data {
  late String uid;
  late String name;
  late String password;
  late String profile;
  late String gender;
  late int bill;
  late int level;
  late String backgroundImg;
  late String email;
  late String birth;
  late String city;
  late String exp;

  Data({
    String uid = "00000000",
    String name = "小明",
    String password = "123456",
    String profile = "这个用户懒的离谱，连简介都没有",
    String gender = "",
    int bill = 0,
    int level = 0,
    String backgroundImg = "assets/images/defaultHeader.jpg",
    String email = "",
    String birth = "2021-07-07",
    String city = "广州",
    String exp = "0",
  }) {
    this.uid = uid;
    this.name = name;
    this.password = password;
    this.profile = profile;
    this.gender = gender;
    this.bill = bill;
    this.level = level;
    this.backgroundImg = backgroundImg;
    this.email = email;
    this.birth = birth;
    this.city = city;
    this.exp = exp;
  }

  Data.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'] ?? uid;
    password = json['password'];
    profile = json['profile'] ?? "这个用户懒的离谱，连简介都没有";
    gender = json['gender'] ?? "";
    bill = json['bill'];
    level = json['level'];
    backgroundImg = json['backgroundImg'] ?? "assets/images/defaultHeader.jpg";
    email = json['email'];
    birth = json['birth'] ?? "2001-01-01";
    city = json['city'] ?? "";
    exp = json['exp'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['password'] = this.password;
    data['profile'] = this.profile;
    data['gender'] = this.gender;
    data['bill'] = this.bill;
    data['level'] = this.level;
    data['backgroundImg'] = this.backgroundImg;
    data['email'] = this.email;
    data['birth'] = this.birth;
    data['city'] = this.city;
    data['exp'] = this.exp;
    return data;
  }
}
