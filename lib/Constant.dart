import 'dart:io';

String serverDomain = Platform.environment['serverDomain'] ?? 'ws://localhost:8080';

int robotQQ = int.tryParse(Platform.environment["robotQQ"].toString()) ?? 33057788;
int masterQQ = int.tryParse(Platform.environment["masterQQ"].toString()) ?? 247209930;
const installBGroupQQ = 342854392;

extension MsgObject on Map {
  bool get isFriendMessage {
    return this['data']['type'] == eRecvMsg.friendMessage.command;
  }

  bool get isGroupMessage {
    return this['data']['type'] == eRecvMsg.groupMessage.command;
  }

  bool get isTempMessage {
    return this['data']['type'] == eRecvMsg.tempMessage.command;
  }

  bool get isStrangerMessage {
    return this['data']['type'] == eRecvMsg.strangerMessage.command;
  }

  bool get isOtherClientMessage {
    return this['data']['type'] == eRecvMsg.otherClientMessage.command;
  }
}

enum eSendCommand {
  friendMessage,
  tempMessage,
  groupMessage,
}

extension eSendCommandX on eSendCommand {
  String get command {
    switch (this) {
      case eSendCommand.friendMessage:
        return 'sendFriendMessage';
      case eSendCommand.tempMessage:
        return 'sendTempMessage';
      case eSendCommand.groupMessage:
        return 'sendGroupMessage';
    }
  }

  String get name {
    switch (this) {
      case eSendCommand.friendMessage:
        return '发送好友消息';
      case eSendCommand.tempMessage:
        return '发送临时会话消息';
      case eSendCommand.groupMessage:
        return '发送群消息';
    }
  }
}

enum eRecvMsg {
  friendMessage,
  tempMessage,
  groupMessage,
  strangerMessage,
  otherClientMessage,
}

extension eRecvMsgX on eRecvMsg {
  String get command {
    switch (this) {
      case eRecvMsg.friendMessage:
        return 'FriendMessage';
      case eRecvMsg.tempMessage:
        return 'TempMessage';
      case eRecvMsg.groupMessage:
        return 'GroupMessage';
      case eRecvMsg.strangerMessage:
        return 'StrangerMessage';
      case eRecvMsg.otherClientMessage:
        return 'OtherClientMessage';
    }
  }
}

enum eMsgItem {
  source,
  quote,
  at,
  face,
  plain,
  image,
  flashImage,
  voice,
  xml,
  json,
  app,
  poke,
  dice,
  musicShare,
  forward,
  file,
}

extension eMsgItemX on eMsgItem {
  String get command {
    switch (this) {
      case eMsgItem.source:
        return 'Source';
      case eMsgItem.quote:
        return 'Quote';
      case eMsgItem.at:
        return 'At';
      case eMsgItem.face:
        return 'Face';
      case eMsgItem.plain:
        return 'Plain';
      case eMsgItem.image:
        return 'Image';
      case eMsgItem.flashImage:
        return 'FlashImage';
      case eMsgItem.voice:
        return 'Voice';
      case eMsgItem.xml:
        return 'Xml';
      case eMsgItem.json:
        return 'Json';
      case eMsgItem.app:
        return 'App';
      case eMsgItem.poke:
        return 'Poke';
      case eMsgItem.dice:
        return 'Dice';
      case eMsgItem.musicShare:
        return 'MusicShare';
      case eMsgItem.forward:
        return 'Forward';
      case eMsgItem.file:
        return 'File';
    }
  }
}

const pathImage = 'asset/images';

const assetLogo1 = '$pathImage/login/logo1.png';
const assetLogo2 = '$pathImage/login/logo2.png';
const assetLogo3 = '$pathImage/login/logo3.png';
const assetbtnCyberStarExplore_1 = '$pathImage/cyberStar/main/btnExplore_1.png';
const assetbtnCyberStarExplore_2 = '$pathImage/cyberStar/main/btnExplore_2.png';
const assetbtnCyberStarMessage_1 = '$pathImage/cyberStar/main/btnMessage_1.png';
const assetbtnCyberStarMessage_2 = '$pathImage/cyberStar/main/btnMessage_2.png';
const assetbtnCyberStarMy_1 = '$pathImage/cyberStar/main/btnMy_1.png';
const assetbtnCyberStarMy_2 = '$pathImage/cyberStar/main/btnMy_2.png';
const assetbtnCyberStarTask_1 = '$pathImage/cyberStar/main/btnTask_1.png';
const assetbtnCyberStarTask_2 = '$pathImage/cyberStar/main/btnTask_2.png';
const assetbtnCyberStarHeart_empty = '$pathImage/cyberStar/main/heart_empty.png';
const assetbtnCyberStarHeart_full = '$pathImage/cyberStar/main/heart_full.png';
const assetbtnEmployerExplore_1 = '$pathImage/employer/main/btnExplore_1.png';
const assetbtnEmployerExplore_2 = '$pathImage/employer/main/btnExplore_2.png';
const assetbtnEmployerMessage_1 = '$pathImage/employer/main/btnMessage_1.png';
const assetbtnEmployerMessage_2 = '$pathImage/employer/main/btnMessage_2.png';
const assetbtnEmployerMy_1 = '$pathImage/employer/main/btnMy_1.png';
const assetbtnEmployerMy_2 = '$pathImage/employer/main/btnMy_2.png';
const assetbtnEmployerTask_1 = '$pathImage/employer/main/btnTask_1.png';
const assetbtnEmployerTask_2 = '$pathImage/employer/main/btnTask_2.png';
const assetbtnSetting = '$pathImage/cyberStar/my/btnSetting.png';
const assetimgCyberStarCellphoneWarning = '$pathImage/cyberStar/my/imgCellphoneWarning.png';
const assetimgEmployerCellphoneWarning = '$pathImage/employer/my/imgCellphoneWarning.png';
const asseticonInviteLimit = '$pathImage/icon/iconInviteLimit.png';
const asseticonAlipay = '$pathImage/icon/iconAlipay.png';
const asseticonPlatformBind = '$pathImage/icon/iconPlatformBind.png';
const asseticonRightArrow = '$pathImage/icon/iconRightArrow_1.png';
const asseticonRightArrowBlack = '$pathImage/icon/iconRightArrow_Black.png';
const assetionTA = '$pathImage/icon/TA.png';
const asseticonLeftArrowBlack = '$pathImage/icon/iconLeftArrowBlack.png';
const asseticonLeftArrowWhite = '$pathImage/icon/iconLeftArrowWhite.png';
const asseticonBrand = '$pathImage/icon/iconBrand.png';
final asseticonDownArrow = '$pathImage/icon/iconDownArrow.png';
const asseticonUpArrowDouble = '$pathImage/icon/iconUpArrowDouble.png';
const asseticonDownArrowDouble = '$pathImage/icon/iconDownArrowDouble.png';
const asseticonFans = '$pathImage/icon/iconFans.png';
const asseticonFans_1 = '$pathImage/icon/iconFans_1.png';
const asseticonFile = '$pathImage/icon/iconFile.png';
const asseticonAddress = '$pathImage/icon/iconAddress.png';
const asseticonQQ = '$pathImage/icon/iconQQ.png';
const asseticonSend = '$pathImage/icon/send.png';
const asseticonWeChat = '$pathImage/icon/iconWeChat.png';
const asseticonFollower = '$pathImage/icon/iconFollower.png';
const asseticonNote = '$pathImage/icon/iconNote.png';
const asseticonChange = '$pathImage/platformLogo/change.png';
const asseticonSingleDropmenu = '$pathImage/platformLogo/single_dropmenu.png';
const asseticonDropmenu = '$pathImage/platformLogo/dropmenu.png';
const asseticonDropmenu9 = '$pathImage/platformLogo/dropmenu.9.png';
const asseticonFilter = '$pathImage/icon/iconFilter.png';
const assetRedLeading = '$pathImage/platformLogo/red_leading.png';
const assetdouyin_shop = '$pathImage/platformLogo/douyin_shop.png';
const assetkuaishou_shop = '$pathImage/platformLogo/kuaishou_shop.png';
const assetredbook_shop = '$pathImage/platformLogo/shop_redbook.png';
const assetAvatarCircle = '$pathImage/platformLogo/circle.png';
const assetfavorite = '$pathImage/platformLogo/favorite.png';
const assetfavorite_border = '$pathImage/platformLogo/favorite_border.png';
const assetshare_forward = '$pathImage/platformLogo/share_forward.png';
const assetDiTu = '$pathImage/platformLogo/ditu.png';

const assetThirdPartLogin = '$pathImage/login/thirdPartLogin.png';
const assetNetError = '$pathImage/login/netError.png';
const assetIIcon = '$pathImage/login/i.png';
const assetTimer = '$pathImage/icon/timer.png';
const assetYellow = '$pathImage/icon/YellowConfirm.png';
const assetphone = '$pathImage/phone.png';

///任务状态 9界
const assetWaitToPublish = '$pathImage/taskStatus/waitToPublish.png';
const assetFinish = '$pathImage/taskStatus/finish.png';
const assetWaitToCheck = '$pathImage/taskStatus/waitToCheck.png';
const assetWaitToConfirm = '$pathImage/taskStatus/waitToConfirm.png';
const assetWaitToEvaluation = '$pathImage/taskStatus/waitToEvaluation.png';
const assetUncooperative = '$pathImage/taskStatus/Uncooperative.png';
const assetCooperativeForSure = '$pathImage/taskStatus/cooperativeForSure.png';
const assetPassSign = '$pathImage/taskStatus/passSign.png';
const assetFail = '$pathImage/taskStatus/fail.png';

///平台绑定
const asseticonPBOther = '$pathImage/icon/iconPlatformOther.png';

///上传文件的底框
const asseticonAddDetailImg = '$pathImage/icon/iconAddDetailImg.png';

///删除角标
const asseticonRemoveDetailImg = '$pathImage/icon/iconRemoveDetailImg.png';

///任务
const assetbtnTaskFavorite_1 = '$pathImage/cyberStar/task/btnFavorite_1.png';
const assetbtnTaskFavorite_2 = '$pathImage/cyberStar/task/btnFavorite_2.png';

///任务详情用 收藏按钮
const assetbtnTaskFavorite_3 = '$pathImage/cyberStar/task/btnFavorite_3.png';
const assetbtnTaskFavorite_4 = '$pathImage/cyberStar/task/btnFavorite_4.png';
const assetbtnTaskSigned_1 = '$pathImage/cyberStar/task/btnSigned_1.png';
const assetbtnTaskSigned_2 = '$pathImage/cyberStar/task/btnSigned_2.png';
const assetbtnTaskProcessing_1 = '$pathImage/cyberStar/task/btnProcessing_1.png';
const assetbtnTaskProcessing_2 = '$pathImage/cyberStar/task/btnProcessing_2.png';
const assetbtnTaskDone_1 = '$pathImage/cyberStar/task/btnDone_1.png';
const assetbtnTaskDone_2 = '$pathImage/cyberStar/task/btnDone_2.png';
const assettaskImgPlaceholder = '$pathImage/cyberStar/task/taskImgPlaceholder.png';
const assettextCommunicating = '$pathImage/cyberStar/task/textCommunicating.png';
const asseticonCommunicating = '$pathImage/cyberStar/task/iconCommunicating.png';
const asseticonNotStart = '$pathImage/icon/iconNotStart.png';
const asseticonOngoing = '$pathImage/icon/iconOngoing.png';
const assetbtnCommunicate = '$pathImage/cyberStar/task/btnCommunicate.png';
const asseticonSuccessGreen = '$pathImage/icon/iconSuccessGreen.png';
const assettextSuccess = '$pathImage/cyberStar/task/textSuccess.png';
const asseticonSuccess = '$pathImage/cyberStar/task/iconSuccess.png';
const asseticonFail_1 = '$pathImage/cyberStar/task/iconFail_1.png';
const assettextFail = '$pathImage/cyberStar/task/textFail.png';
const asseticonStar1 = '$pathImage/cyberStar/task/iconStar1.png';
const asseticonStar2 = '$pathImage/cyberStar/task/iconStar2.png';
const asseticonValuation = '$pathImage/cyberStar/task/iconValuation.png';
const asseticonValuationSuc = '$pathImage/cyberStar/task/iconValuationSuc.png';
const assettextMake = '$pathImage/cyberStar/task/textMake.png';
const asseticonMake = '$pathImage/cyberStar/task/iconMake.png';
const assettextPublish = '$pathImage/cyberStar/task/textPublish.png';
const assettextPublishConfirm = '$pathImage/cyberStar/task/textPublishConfirm.png';
const asseticonPublish = '$pathImage/cyberStar/task/iconPublish.png';
const assettextReview = '$pathImage/cyberStar/task/textReview.png';
const asseticonReview = '$pathImage/cyberStar/task/iconReview.png';
const assettextReviewFail = '$pathImage/cyberStar/task/textReviewFail.png';
const asseticonReviewFail = '$pathImage/cyberStar/task/iconReviewFail.png';
const assettextValuation1 = '$pathImage/cyberStar/task/textValuation1.png';
const assettextValuation2 = '$pathImage/cyberStar/task/textValuation2.png';
const assettextValuation3 = '$pathImage/cyberStar/task/textValuation3.png';
const asseticonExpandMore = '$pathImage/cyberStar/task/iconExpandMore.png';
const asseticonRightArrow_2 = '$pathImage/icon/iconRightArrow_2.png';
const assetEmployerPublishTask = ['$pathImage/employer/task/publish1.png', '$pathImage/employer/task/publish2.png'];
const assetEmployerManagerTask = ['$pathImage/employer/task/task_manager1.png', '$pathImage/employer/task/task_manager2.png'];
/*
  none,
  examining, //审核中
  recruiting, //招募中
  ongoing, //进行中
  offState, //截止
  examineFail, //审核失败
  taskFail, //失败
 */
const assetEmployerTaskState = [
  '',
  '$pathImage/employer/task/task_state_0.png', ////审核中
  '$pathImage/employer/task/task_state_1.png', ////招募中
  '$pathImage/employer/task/task_state_2.png', ////进行中
  '$pathImage/employer/task/task_state_3.png', ////截止
  '',
  '$pathImage/employer/task/task_state_4.png', ////失败
];
const assetEmployerTaskMoney = '$pathImage/employer/task/money.png';
const assetEmployerbtnPublishTask = '$pathImage/employer/task/btnPublishTask.png';
const assetTaskPublishFailTips = '$pathImage/icon/star_in_tips.png';

const assetWechat = '$pathImage/platformLogo/wechat.png';

///金主任务
const emassetGreyCircle = '$pathImage/employer/mission/employer_circle_grey.png';
const emassetYellowCircle = '$pathImage/employer/mission/employer_circle_yellow.png';
const emassetDashLine = '$pathImage/employer/mission/employer_dashline.png';
const emassetIconAddPeople = '$pathImage/employer/mission/employer_icon_addpeople.png';
const emassetIconClock = '$pathImage/employer/mission/employer_icon_clock.png';
const emassetIconCircleGou = '$pathImage/employer/mission/employer_icon_circleGou.png';
const emassetIconAddMember = '$pathImage/employer/mission/employer_icon_addMember.png';
const emassetIconIng = '$pathImage/employer/mission/employer_icon_ing.png';
const emassetIconLight = '$pathImage/employer/mission/employer_icon_light.png';
const emassetIconUnpass = '$pathImage/employer/mission/employer_icon_unpass.png';
const emassetIconDfb = '$pathImage/employer/mission/employer_icon_dfb.png';
const emassetIconFly = '$pathImage/employer/mission/employer_icon_fly.png';
const emassetIconBird = '$pathImage/employer/mission/employer_icon_bird.png';
const emassetIconGou = '$pathImage/employer/mission/employer_icon_gou.png';
const emassetIconHeart = '$pathImage/employer/mission/employer_icon_heart.png';
const emassetIconHourGlass = '$pathImage/employer/mission/employer_icon_hourglass.png';
const emassetIconPpb = '$pathImage/employer/mission/employer_icon_ppb.png';
const emassetIconRun = '$pathImage/employer/mission/employer_icon_run.png';
const emassetIconStar = '$pathImage/employer/mission/employer_icon_star.png';
const emassetStrDdsh = '$pathImage/employer/mission/employer_str_ddsh.png';
const emassetStrJxz = '$pathImage/employer/mission/employer_str_jxz.png';
const emassetStrYwc = '$pathImage/employer/mission/employer_str_ywc.png';
const emassetStrZmz = '$pathImage/employer/mission/employer_str_zmz.png';
const emassetStrZmsb = '$pathImage/employer/mission/employer_str_zmsb.png';
const emassetStrUnpass = '$pathImage/employer/mission/employer_str_unpass.png';
const emassetTipBg = '$pathImage/employer/mission/employer_tipBg.png';
const emassetYellowLine = '$pathImage/employer/mission/employer_yellowLine.png';
const emassetIconHeart1 = '$pathImage/employer/mission/employer_icon_heart1.png';
const emassetIconHeart2 = '$pathImage/employer/mission/employer_icon_heart2.png';
const emassetIconShare = '$pathImage/employer/mission/employer_icon_share.png';
const emassetIconTalk = '$pathImage/employer/mission/employer_icon_talk.png';
const emassetIconHeadphone = '$pathImage/icon/headphone.png';

///金主评价
const eaassetStateStr = [
  '$pathImage/employer/appraise/text_fbpj.png',
  '$pathImage/employer/appraise/text_pjcg.png',
  '$pathImage/employer/appraise/text_ypj.png',
];
const eaasetIconAppraise = '$pathImage/employer/appraise/icon_appraise.png';
const eaasetIconAppraising = '$pathImage/employer/appraise/icon_appraise_ing.png';
const eaasetIcon1 = '$pathImage/employer/appraise/icon1.png';
const eaasetIconGou = '$pathImage/employer/appraise/iconGou.png';
const eaasetStarFull = '$pathImage/employer/appraise/star_full.png';
const eaasetStarEmpty = '$pathImage/employer/appraise/star_empty.png';

///金主认证
const ecassetIcon1 = '$pathImage/employer/certificate/employerc_icon1.png';
const ecassetIcon2 = '$pathImage/employer/certificate/employerc_icon2.png';
const ecassetIcon3 = '$pathImage/employer/certificate/employerc_icon3.png';
const ecassetIcon4 = '$pathImage/employer/certificate/employerc_icon4.png';
const ecassetIcon5 = '$pathImage/employer/certificate/employerc_icon5.png';
const ecassetIcon6 = '$pathImage/employer/certificate/employerc_icon6.png';
const ecassetIcon7 = '$pathImage/employer/certificate/employerc_icon7.png';
const ecassetIcon8 = '$pathImage/employer/certificate/employerc_icon8.png';
const ecassetIcon9 = '$pathImage/employer/certificate/employerc_icon9.png';
const ecassetIcon10 = '$pathImage/employer/certificate/employerc_icon10.png';
const ecassetIcon11 = '$pathImage/employer/certificate/employerc_icon11.png';
const ecassetIcon12 = '$pathImage/employer/certificate/employerc_icon12.png';
const ecassetIcon13 = '$pathImage/employer/certificate/employerc_icon13.png';
const ecassetIcon14 = '$pathImage/employer/certificate/employerc_icon14.png';
const ecassetLine1 = '$pathImage/employer/certificate/employerc_line1.png';
const ecassetLine2 = '$pathImage/employer/certificate/employerc_line2.png';
const ecassetLine3 = '$pathImage/employer/certificate/employerc_line3.png';

///金主通用
const ecmassetFunsIcon = '$pathImage/employer/common/funsIcon.png';
const ecmassetRegionIcon = '$pathImage/employer/common/regionIcon.png';
const ecmassetTextIcon = '$pathImage/employer/common/textIcon.png';

const assetBtnClear = '$pathImage/common/btnClear.png';
const assetBtnNote = '$pathImage/common/btnNote.png';
const assetBtnNoted = '$pathImage/common/btnNoted.png';

///分享
const sassetdownload = '$pathImage/share/download.png';
const sassetlink = '$pathImage/share/link.png';
const sassetpicture = '$pathImage/share/picture.png';
const sassetqq = '$pathImage/share/qq.png';
const sassetqqzone = '$pathImage/share/qqzone.png';
const sassetreport = '$pathImage/share/report.png';
const sassetwebchat = '$pathImage/share/webchat.png';
const sassetweibo = '$pathImage/share/weibo.png';
const sassetwxcircle = '$pathImage/share/wxcircle.png';

///查看更多的底图
const assetMoreBG = '$pathImage/cyberStar/task/imgMoreBG.png';
const assetTaskDetailBG = '$pathImage/cyberStar/task/imgTaskDetailBG.png';
const assetIconFileWord = '$pathImage/icon/iconFileWord.png';
const assetIconFileExcel = '$pathImage/icon/iconFileExcel.png';
const assetIconFilePDF = '$pathImage/icon/iconFilePDF.png';
const assetIconFilePPT = '$pathImage/icon/iconFilePPT.png';
const assetIconFileVideo = '$pathImage/icon/iconFileVideo.png';
const assetIconFileOther = '$pathImage/icon/iconFileOther.png';
const assetNoMoreData = '$pathImage/imgNoMoreData.png';
const assetTagVIP = '$pathImage/icon/tagVIP.png';
const assetTagVIPGrey = '$pathImage/icon/tagVIPGrey.png';
const assetIconLockOpen = '$pathImage/icon/iconLockOpen.png';
const assetIconLockClose = '$pathImage/icon/iconLockClose.png';
const assetXin = '$pathImage/icon/xin.png';
const assetQuestion = '$pathImage/icon/question.png';
const assetIconSearch = '$pathImage/icon/iconSearch.png';
const assetFire = '$pathImage/icon/fire.png';
const assetRubbish = '$pathImage/icon/rubbish.png';
const assetLogo = '$pathImage/logo.png';
const assetTagDeposit = '$pathImage/icon/tagDeposit.png';

///法律条文图片
const assetRemuneration_1 = '$pathImage/Protocol/Remuneration_1.png';
const assetRemuneration_2 = '$pathImage/Protocol/Remuneration_2.png';

///通用图片
const cassetCooperateFail = '$pathImage/common/tip_cooperateFail.png';
const cassetDoSomething = '$pathImage/common/tip_doSomething.png';
const cassetEmpty = '$pathImage/common/tip_empty.png';
const cassetFail = '$pathImage/common/tip_fail.png';
const cassetNeedHelp = '$pathImage/common/tip_needHelp.png';
const cassetNetDisconnection = '$pathImage/common/tip_netDisconnection.png';
const cassetNetError = '$pathImage/common/tip_netError.png';
const cassetimgAvatarBG = '$pathImage/common/imgAvatarBG.png';
const cassetgradientBG = '$pathImage/common/gradientBG.png';

///vip
const assetVipGotoPayBtn = '$pathImage/vip/gotoPayBtn.png';
const assetVipMonthReportBtn = '$pathImage/vip/monthReportBtn.png';
const assetVipPayBtn = '$pathImage/vip/payBtn.png';
const assetVipPrivilegeIcon1 = '$pathImage/vip/privilegeIcon1.png';
const assetVipPrivilegeIcon2 = '$pathImage/vip/privilegeIcon2.png';
const assetVipPrivilegeIcon3 = '$pathImage/vip/privilegeIcon3.png';
const assetVipPrivilegeIcon4 = '$pathImage/vip/privilegeIcon4.png';
const assetVipPrivilegeIcon5 = '$pathImage/vip/privilegeIcon5.png';
const assetVipPrivilegeIcon6 = '$pathImage/vip/privilegeIcon6.png';
const assetVipPrivilegeText = '$pathImage/vip/privilegeText.png';
const assetVipTitleBg1 = '$pathImage/vip/titleBg1.png';
const assetVipTitleBg2 = '$pathImage/vip/titleBg2.png';
const assetVipVipTypeBgNormal = '$pathImage/vip/vipTypeBgNormal.png';
const assetVipVipTypeBgSelect = '$pathImage/vip/vipTypeBgSelect.png';
const assetVipVipTypeText = '$pathImage/vip/vipTypeText.png';

///monthReport
const assetMR0 = '$pathImage/vip/monthReport/0.png';
const assetMR1 = '$pathImage/vip/monthReport/1.png';
const assetMR2 = '$pathImage/vip/monthReport/2.png';
const assetMR3 = '$pathImage/vip/monthReport/3.png';
const assetMR4 = '$pathImage/vip/monthReport/4.png';
const assetMR5 = '$pathImage/vip/monthReport/5.png';
const assetMR6 = '$pathImage/vip/monthReport/6.png';
const assetMR7 = '$pathImage/vip/monthReport/7.png';
const assetMR8 = '$pathImage/vip/monthReport/8.png';
const assetMR9 = '$pathImage/vip/monthReport/9.png';
const assetMRBg1 = '$pathImage/vip/monthReport/bg1.png';
const assetMRBg2 = '$pathImage/vip/monthReport/bg2.png';
const assetMRBottom1 = '$pathImage/vip/monthReport/bottom1.png';
const assetMRBottom2 = '$pathImage/vip/monthReport/bottom2.png';
const assetMRBottomCenter1 = '$pathImage/vip/monthReport/bottomCenter1.png';
const assetMRCenter2 = '$pathImage/vip/monthReport/center2.png';
const assetMRHeadCover = '$pathImage/vip/monthReport/headCover.png';
const assetMRText2 = '$pathImage/vip/monthReport/text2.png';
const assetMRTextBg1 = '$pathImage/vip/monthReport/textBg1.png';
const assetMRTextBg21 = '$pathImage/vip/monthReport/textBg21.png';
const assetMRTextBg22 = '$pathImage/vip/monthReport/textBg22.png';
const assetMRTextBg23 = '$pathImage/vip/monthReport/textBg23.png';
const assetMRTextBg24 = '$pathImage/vip/monthReport/textBg24.png';
const assetMRTitle1 = '$pathImage/vip/monthReport/title1.png';

initConstant() {}

///微信错误码
enum WXErrCode {
  ///成功 = 0
  WXSuccess,

  ///普通错误类型 = -1
  WXErrCodeCommon,

  ///用户点击取消并返回 = -2
  WXErrCodeUserCancel,

  ///发送失败 = -3
  WXErrCodeSentFail,

  ///授权失败 = -4
  WXErrCodeAuthDeny,

  ///微信不支持 = -5
  WXErrCodeUnsupport,
}

///微信请求发送场景
enum WXScene {
  ///聊天界面
  WXSceneSession,

  ///朋友圈
  WXSceneTimeline,

  ///收藏
  WXSceneFavorite,

  ///指定联系人
  WXSceneSpecifiedSession,
}

enum WXAPISupport {
  WXAPISupportSession,
}

///微信跳转profile类型
enum WXBizProfileType {
  ///普通公众号
  WXBizProfileType_Normal,

  ///硬件公众号
  WXBizProfileType_Device,
}

///微信分享小程序类型
enum WXMiniProgramType {
  ///正式版
  WXMiniProgramTypeRelease,

  ///开发版
  WXMiniProgramTypeTest,

  ///体验版
  WXMiniProgramTypePreview,
}

///微信跳转mp网页类型
enum WXMPWebviewType {
  ///广告网页
  WXMPWebviewType_Ad,
}
