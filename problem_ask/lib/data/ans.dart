class Answer {
  late String status;
  late Data data;

  Answer({String s = "?"}) {
    this.status = s;
    this.data = new Data();
  }

  Answer.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = new Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    return data;
  }
}

class Data {
  late String aid;
  late String content;
  late String pid;
  late String uid;
  late String time;
  late int like;

  Data({
    String aid = "",
    String content = "",
    String pid = "",
    String uid = "",
    String time = "",
    int like = 0,
  }) {
    this.aid = aid;
    this.content = content;
    this.pid = pid;
    this.uid = uid;
    this.like = like;
    this.time = time;
  }

  Data.fromJson(Map<String, dynamic> json) {
    aid = json['aid'];
    content = json['content'];
    pid = json['pid'];
    uid = json['uid'];
    like = json['like'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['aid'] = this.aid;
    data['content'] = this.content;
    data['pid'] = this.pid;
    data['uid'] = this.uid;
    data['like'] = this.like;
    data['time'] = this.time;
    return data;
  }
}
