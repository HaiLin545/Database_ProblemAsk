class Problem {
  late String status;
  late Data data;

  Problem({String s = "Not found!"}) {
    this.status = s;
    this.data = new Data();
  }

  Problem.fromJson(Map<String, dynamic> json) {
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
  late String pid;
  late String confirmedAid;
  late String time;
  late String content;
  late String title;
  late String tag;
  late int bill;
  late int ansNum;
  late List pic_url;
  late int pic_num;

  Data({
    String uid = "",
    String pid = "1",
    String confirmedAid = "0",
    String time = "",
    String content = "",
    String title = "",
    String tag = "",
    int bill = 0,
    int ansNum = 0,
    int pic_num = -1,
  }) : pic_url = [] {
    this.uid = uid;
    this.pid = pid;
    this.confirmedAid = confirmedAid;
    this.time = time;
    this.content = content;
    this.tag = tag;
    this.bill = bill;
    this.ansNum = ansNum;
    this.pic_num = pic_num;
  }

  Data.fromJson(Map<String, dynamic> json) {
    // print(json.toString());
    uid = json['uid'] ?? "";
    pid = json['pid'] ?? "";
    confirmedAid = json['confirmedAid'] ?? "";
    time = json['time'] ?? "";
    content = json['content'] ?? "";
    tag = json['tag'] ?? "";
    title = json['title'] ?? "";
    bill = json['bill'] ?? "";
    ansNum = json['ans_num'] ?? "";
    pic_num = json['pic_num'] ?? -1;
    pic_url = (json['pic_url'] as List<dynamic>).cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['pid'] = this.pid;
    data['confirmedAid'] = this.confirmedAid;
    data['time'] = this.time;
    data['content'] = this.content;
    data['title'] = this.title;
    data['tag'] = this.tag;
    data['bill'] = this.bill;
    data['ans_num'] = this.ansNum;
    data['url'] = this.pic_url;
    data['pic_num'] = this.pic_num;
    return data;
  }
}
