class ModelFromServer {
  String syncId = '-1';
  late Map data;

  ModelFromServer.fromJson(Map json) {
    syncId = json['syncId'];
    data = json['data'];
  }
}

class MemberProfile extends ModelFromServer {
  late String nickname;
  late String email;
  late int age;
  late int level;
  late String sign;

  ///UNKNOWN, MALE, FEMALE
  late String sex;

  MemberProfile.fromJson(Map json) : super.fromJson(json) {
    nickname = data['nickname'];
    email = data['email'];
    age = data['age'];
    level = data['level'];
    sign = data['sign'];
    sex = data['sex'];
  }
}
