import '../util.dart';
import 'model.dart';
import 'sender.dart';

class Message extends ModelFromServer {
  late List messageChain;
  late Sender sender;

  Message.fromJson(Map json) : super.fromJson(json);
}

class RecvGroupMessage extends Message {
  RecvGroupMessage.fromJson(Map json) : super.fromJson(json) {
    messageChain = parseMsgChain(data['messageChain']);
    sender = GroupMsgSender.fromJson(data['sender']);
  }
}

class RecvFriendMessage extends Message {
  RecvFriendMessage.fromJson(Map json) : super.fromJson(json) {
    messageChain = parseMsgChain(data['messageChain']);
    sender = FriendMsgSender.fromJson(data['sender']);
  }
}

class MsgItemSource {
  late String type;

  ///消息的识别号，用于引用回复（Source类型永远为chain的第一个元素）
  late int id;
  late int time;

  MsgItemSource.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    time = json['time'];
  }
}

class MsgItemPlain {
  late String type;
  late String text;

  MsgItemPlain.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    text = json['text'];
  }
}

class MsgItemQuote {
  late String type;

  ///被引用回复的原消息的messageId
  late int id;

  ///被引用回复的原消息所接收的群号，当为好友消息时为0
  late int groupId;

  ///被引用回复的原消息的发送者的QQ号
  late int senderId;

  ///被引用回复的原消息的接收者者的QQ号（或群号）
  late int targetId;

  ///被引用回复的原消息的消息链对象
  late Map origin;

  MsgItemQuote.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    id = json['id'];
    groupId = json['groupId'];
    senderId = json['senderId'];
    targetId = json['targetId'];
    origin = json['origin'];
  }
}

class MsgItemAt {
  late String type;

  ///群员QQ号
  late int target;

  ///At时显示的文字，发送消息时无效，自动使用群名片
  late String display;

  MsgItemAt.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    target = json['target'];
    display = json['display'];
  }
}

class MsgItemAtAll {
  late String type;
}

class MsgItemFace {
  late String type;

  ///QQ表情编号，可选，优先高于name
  late int faceId;

  ///QQ表情拼音，可选
  late String name;
}

///三个参数任选其一，出现多个参数时，按照imageId > url > path的优先级
class MsgItemImage {
  late String type;

  ///图片的imageId，群图片与好友图片格式不同。不为空时将忽略url属性
  late String imageId;

  ///图片的URL，发送时可作网络图片的链接；接收时为腾讯图片服务器的链接，可用于图片下载
  late String url;

  ///图片的路径，发送本地图片，相对路径于plugins/MiraiAPIHTTP/images
  late String path;
}

///三个参数任选其一，出现多个参数时，按照imageId > url > path的优先级
class MsgItemFlashImage {
  late String type;

  ///图片的imageId，群图片与好友图片格式不同。不为空时将忽略url属性
  late String imageId;

  ///图片的URL，发送时可作网络图片的链接；接收时为腾讯图片服务器的链接，可用于图片下载
  late String url;

  ///图片的路径，发送本地图片，相对路径于plugins/MiraiAPIHTTP/images
  late String path;
}

///三个参数任选其一，出现多个参数时，按照voiceId > url > path的优先级
class MsgItemVoice {
  late String type;

  ///语音的voiceId，不为空时将忽略url属性
  late String voiceId;

  ///语音的URL，发送时可作网络语音的链接；接收时为腾讯语音服务器的链接，可用于语音下载
  late String url;

  ///语音的路径，发送本地语音，相对路径于plugins/MiraiAPIHTTP/voices
  late String path;
}

class MsgItemXml {
  late String type;
  late String xml;
}

class MsgItemJson {
  late String type;
  late String json;
}

class MsgItemApp {
  late String type;
  late String content;
}

class MsgItemPoke {
  late String type;

  ///戳一戳的类型
  late String name;
}

class MsgItemDice {
  late String type;

  ///点数
  late int value;
}

class MsgItemMusicShare {
  late String type;
  late String kind;
  late String title;

  ///概括
  late String summary;
  late String jumpUrl;
  late String pictureUrl;
  late String musicUrl;

  ///简介
  late String brief;
}

class MsgItemForwardMessage {
  late String type;
  late Map nodeList;
}

class MsgItemFile {
  late String type;
  late String id;
  late String name;
  late int size;
}
