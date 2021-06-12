import '/Constant.dart';
import '/model/Message.dart';
import 'manager/QQManager.dart';
import 'model/Sender.dart';

List parseMsgChain(List list) {
  List ret = [];
  for (var ele in list) {
    if (ele['type'] == eMsgItem.source.command) {
      ret.add(MsgItemSource.fromJson(ele));
    } else if (ele['type'] == eMsgItem.at.command) {
      ret.add(MsgItemAt.fromJson(ele));
    } else if (ele['type'] == eMsgItem.plain.command) {
      ret.add(MsgItemPlain.fromJson(ele));
    }
  }
  return ret;
}

buildPlainMsgItem(String text) {
  return buildMsgItem(eMsgItem.plain, text);
}

buildImageMsgItem({String? imageId, String? url, String? path}) {
  return buildMsgItem(eMsgItem.image, {
    if (imageId != null && imageId != '') 'imageId': imageId,
    if (url != null && url != '') 'url': url,
    if (path != null && path != '') 'path': path,
  });
}

buildMsgItem(eMsgItem type, content) {
  if (type == eMsgItem.plain) {
    return {'type': eMsgItem.plain.command, 'text': content};
  }
  if (type == eMsgItem.image) {
    return {'type': eMsgItem.image.command, ...content};
  }
}

replyMsg(Message recvMsg, messageChain) {
  if (!(messageChain is List)) {
    messageChain = [messageChain];
  }
  if (recvMsg is RecvGroupMessage) {
    final groupID = (recvMsg.sender as GroupMsgSender).group['id'];
    QQManager().sendGroupMsg(target: groupID, messageChain: messageChain);
  } else if (recvMsg is RecvFriendMessage) {
    final qq = (recvMsg.sender as FriendMsgSender).id;
    QQManager().sendFriendMsg(qq: qq, messageChain: messageChain);
  }
}
