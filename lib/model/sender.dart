import '../slib.dart';

class Sender {
  late int id;

  Sender.fromJson(JSON json) {
    id = json['id'];
  }
}

class GroupMsgSender extends Sender {
  late String memberName;
  String? specialTitle;
  late String permission;
  late int joinTimestamp;
  late int lastSpeakTimestamp;
  late int muteTimeRemaining;
  late JSON group;

  GroupMsgSender.fromJson(JSON json) : super.fromJson(json) {
    memberName = json['memberName'];
    specialTitle = json['specialTitle'];
    group = json['group'];
  }
}

class FriendMsgSender extends Sender {
  late String nickname;
  late String remark;

  FriendMsgSender.fromJson(JSON json) : super.fromJson(json) {
    nickname = json['nickname'];
    remark = json['remark'];
  }
}
