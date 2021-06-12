library slib;

import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;
import 'dart:math';

import 'package:dio/dio.dart';

final isIOS = Platform.isIOS;
final isAndroid = Platform.isAndroid;
final isWindows = Platform.isWindows;
final isFuchsia = Platform.isFuchsia;
final isLinux = Platform.isLinux;
final isMacOS = Platform.isMacOS;

get(String url, {Map<String, dynamic>? queryParameters, retryCount = 3, headers, parseJSON = true, List<Interceptor>? interceptors, timestamp = true}) async {
  var options;
  if (headers != null) {
    options = Options(headers: headers);
  }
  queryParameters ??= {};

  dynamic response;
  final completer = Completer();

  send() async {
    if (timestamp) queryParameters!['v'] = Date.now();
    try {
      final dio = Dio();
      if (interceptors != null) dio.interceptors.addAll(interceptors);
      response = await dio.get(NetUtil.normalizeURL(url), queryParameters: NetUtil.normalizeQueryParams(queryParameters!), options: options);
    } catch (e) {
      if (retryCount-- > 0) {
        print(e.toString());
        await sleep(1000);
        send();
      } else {
        completer.complete({"code": -1, "msg": "网络异常"});
      }
      return;
    }

    //parse json
    if (parseJSON) {
      try {
        response = json.decode(response.toString());
      } catch (e) {
        print(e);
        response = {"code": -2, "msg": "json解析错误"};
      }
    }

    completer.complete(response);
  }

  send();
  return completer.future;
}

post(String url, {queryParameters, body, retryCount = 3, headers, parseJSON = true, List<Interceptor>? interceptors}) async {
  var options;
  if (headers != null) {
    options = Options(headers: headers);
  }

  dynamic response;
  final completer = Completer();

  send() async {
    queryParameters['v'] = Date.now();
    try {
      final dio = Dio();
      if (interceptors != null) dio.interceptors.addAll(interceptors);
      response = await dio.post(NetUtil.normalizeURL(url), data: body, queryParameters: NetUtil.normalizeQueryParams(queryParameters), options: options);
    } catch (e) {
      if (retryCount-- > 0) {
        await sleep(1000);
        send();
      } else {
        completer.complete({"code": -1, "msg": "网络异常"});
      }
      return;
    }

    //parse json
    if (parseJSON) {
      try {
        response = json.decode(response.toString());
      } catch (e) {
        print(e);
        response = {"code": -2, "msg": "json解析错误"};
      }
    }

    completer.complete(response);
  }

  send();
  return completer.future;
}

setTimeout(void Function() cb, timeout) => Timer(Duration(milliseconds: timeout), cb);

clearTimeout(Timer handle) => handle.cancel();

setInterval(void Function(Timer) cb, interval) => Timer.periodic(Duration(milliseconds: interval), cb);

clearInterval(Timer handle) => handle.cancel();

sleep(timeout) async {
  await Future.delayed(Duration(milliseconds: timeout));
}

random({int min = 1, required int max}) {
  return min + Random().nextInt(max - min + 1);
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

String randomString(int len) {
  final r = Random();
  return String.fromCharCodes(List.generate(len, (index) => _chars.codeUnitAt(r.nextInt(_chars.length))));
}

///枚举列表转换成值列表
/// ```dart
/// enumListToValueList([enum.a,enum.b]) === [0,1]
/// ```
List enumListToValueList(e) => e?.map((ele) => ele.index)?.toList();

///枚举列表转换成值字符串
/// ```dart
/// enumListToValueString([enum.a,enum.b]) === '0,1'
/// ```
String enumListToValueString(e, [separator = ',']) => e?.map((ele) => ele.index)?.join(separator);

///数值字符串转换成数值列表
/// ```dart
/// valueStringToValueList('1,2,3') === [1,2,3];
/// ```
valueStringToValueList(String s, [separator = ',']) => s.split(separator).map((ele) => int.parse(ele)).toList();

extension doubleX on double {}

extension StringX on String {
  /// ```dart
  /// '1,2,3'.toListInt() === [1,2,3];
  /// ```
  List<int> toListInt([separator = ',']) {
    return valueStringToValueList(this, separator);
  }

  ///验证手机号格式
  bool get isPhoneNum {
    RegExp exp = RegExp(r'^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$');
    return exp.hasMatch(this);
  }

  ///验证身份证
  bool get isIDCard {
    if (this.length != 18) {
      return false; // 位数不够
    }
    // 身份证号码正则
    RegExp postalCode = new RegExp(r'^[1-9]\d{5}[1-9]\d{3}((0\d)|(1[0-2]))(([0|1|2]\d)|3[0-1])\d{3}([0-9]|[Xx])$');
    // 通过验证，说明格式正确，但仍需计算准确性
    if (!postalCode.hasMatch(this)) {
      return false;
    }
    //将前17位加权因子保存在数组里
    final List idCardList = ["7", "9", "10", "5", "8", "4", "2", "1", "6", "3", "7", "9", "10", "5", "8", "4", "2"];
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    final List idCardYArray = ['1', '0', '10', '9', '8', '7', '6', '5', '4', '3', '2'];
    // 前17位各自乖以加权因子后的总和
    int idCardWiSum = 0;

    for (int i = 0; i < 17; i++) {
      int subStrIndex = int.parse(this.substring(i, i + 1));
      int idCardWiIndex = int.parse(idCardList[i]);
      idCardWiSum += subStrIndex * idCardWiIndex;
    }
    // 计算出校验码所在数组的位置
    int idCardMod = idCardWiSum % 11;
    // 得到最后一位号码
    String idCardLast = this.substring(17, 18);
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if (idCardMod == 2) {
      if (idCardLast != 'x' && idCardLast != 'X') {
        return false;
      }
    } else {
      //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
      if (idCardLast != idCardYArray[idCardMod]) {
        return false;
      }
    }
    return true;
  }

  ///判断是否是微信号
  bool get isWX {
    RegExp exp = RegExp(r'^[a-zA-Z][a-zA-Z\d_-]{5,19}$');
    return exp.hasMatch(this);
  }

  ///获取文件后缀名
  String get getExtName {
    final match = RegExp(r'([^\/\\.\s]+)\.((?:[^\/\\.\s\?]+)+)(?:\?\S+)?$').firstMatch(this);
    return match?.group(2) ?? '';
  }

  ///获取文件名
  get getFileName {
    final match = RegExp(r'([^\/\\.\s]+)(\.[^\/\\.\s]+)?$').firstMatch(this);
    return match?.group(1) ?? '';
  }

  get getFileNameAndExtName {
    final index = this.lastIndexOf('/');
    if (index == -1) return [];
    final index2 = this.lastIndexOf('.');
    if (index2 == -1) return [];
    return [this.substring(index + 1, index2), this.substring(index2 + 1)];
  }

  ///这个字符串里的文件后缀名是否是图片格式
  get isImage {
    final ext = this.getExtName.toLowerCase();
    if (ext == '') return false;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(ext);
  }

  ///是否是网络地址
  get isURL {
    return this.startsWith(RegExp(r'https?://'));
  }

  normalizeAddress() {
    return this.replaceFirst(RegExp(r"北京 ?|上海 ?|天津 ?|重庆 ?|台湾 ?"), "");
  }

  ///是否是直辖市
  get isDirect {
    return this == '北京' || this == '上海' || this == '重庆' || this == '天津' || this == '台湾';
  }
}

extension ListX<T> on List<T> {
  /// ```dart
  /// [enum.a,enum.b].toIndexList === [0,1]
  /// ```
  List get toIndexList => enumListToValueList(this);

  /// ```dart
  /// [enum.a,enum.b].toIndexString() === '0,1'
  /// ```
  String toIndexString([separator = ',']) => enumListToValueString(this);
}

extension ListIntX on List<int> {
  String get toBase64 => base64Encode(this);
}

extension IntX on int {
  String get tenK {
    if (this < 10000) return this.toString();
    return '${this ~/ 10000}W+';
  }
}

class Date {
  static int now() {
    return DateTime.now().millisecondsSinceEpoch;
  }
}

typedef CompleteCallback = void Function(String path);

const notificateNoticeKey = "notificationNotice";

class NetUtil {
  ///正常化 URL
  static normalizeURL(String url) {
    final haveQuestion = url.indexOf('?') != -1;
    final haveEquals = url.indexOf('=') != -1;

    if (haveQuestion) {
      //http://abc.com?
      if (url.endsWith('?')) {
        url = url.substring(0, url.length - 1);
      }
    } else {
      //http://abc.com&aa=1
      if (haveEquals) {
        url = url.replaceFirst(RegExp('&'), '?');
      }
    }
    return url;
  }

  ///删除空值 序列化值
  static normalizeQueryParams(Map<String, dynamic> queryParameters, {arraySeparator = ',', bool2int = true}) {
    queryParameters.updateAll((key, value) {
      if (value is List) {
        if (value.length == 0) return null;
        value = value.join(arraySeparator);
      }
      if ((value is bool) && bool2int) {
        value = value ? 1 : 0;
      }
      return value;
    });
    queryParameters.removeWhere((key, value) => (value == null) || (value == ''));
    return queryParameters;
  }

  ///附加参数
  ///appendQueryParam(url, {name:'abc', age:18}
  static appendQueryParam(String url, Map<String, dynamic> params) {
    url = normalizeURL(url);
    final needAppend = [];
    params.forEach((key, value) {
      needAppend.add('$key=$value');
    });

    final noParam = url.indexOf('?') == -1;
    return url + (noParam ? '?' : '&') + needAppend.join('&');
  }

  ///删除参数
  ///@author https://stackoverflow.com/questions/1634748/how-can-i-delete-a-query-string-parameter-in-javascript/1634841#1634841
  static removeQueryParam(String url, params) {
    url = normalizeURL(url);
    if (params is! List) {
      params = [params];
    }

    final prefixs = [];
    for (var i = 0; i < params.length; i++) {
      prefixs.add(Uri.encodeComponent(params[i]) + '=');
    }
    final urlparts = url.split('?');
    if (urlparts.length >= 2) {
      var pars = urlparts[1].split(RegExp(r'[&;]'));
      print(pars);
      pars = pars.where((el) {
        for (var j = 0; j < prefixs.length; j++) {
          if (el.lastIndexOf(prefixs[j], 0) != -1) {
            return false;
          }
        }
        return true;
      }).toList();
      return urlparts[0] + (pars.length > 0 ? '?' + pars.join('&') : '');
    }
    return url;
  }

  ///格式化带参数的url
  ///@param url
  ///@param params 参数 object
  ///@param replace 无视 url 中自带的参数
  static String formatParamsURL(String url, Map<String, dynamic> params, {bool replace = false, arraySeparator = ',', bool2int = true}) {
    if (url == null || params == null) return url;

    final questionMarkIndex = url.indexOf('?');
    var noQuestionMark = questionMarkIndex == -1;
    if (replace) {
      url = url.substring(0, noQuestionMark ? url.length : questionMarkIndex);
      noQuestionMark = true;
    }

    final arrParams = [];
    params.forEach((key, value) {
      if (value == '') return;
      if (value == null) return;
      if (value is int) {
        value = value.toString();
      }
      if (value is List) {
        value = value.join(arraySeparator);
      }
      if ((value is bool) && bool2int) {
        value = value ? 1 : 0;
      }
      arrParams.add('$key=$value');
    });
    if (arrParams.length > 0) {
      url += noQuestionMark ? '?' : '&';
    }
    url += arrParams.join('&');
//    print('format url $url');
    return url;
  }

  static serializeBody(Map<String, dynamic> json, {bool2int = true}) {
    if (json == null) return null;
    final ret = {};
    json.forEach((key, value) {
      if (value == '') return;
      if (value == null) return;
      if ((value is bool) && bool2int) {
        value = value ? 1 : 0;
      }

      ret[key] = value;
    });
    return ret;
  }
}

// extension DateTimeX on DateTime {
//   format([String newPattern = 'yyyy-MM-dd', String locale]) {
//     return DateFormat(newPattern, locale).format(this);
//   }
//
//   bool isToday() {
//     var now = DateTime.now();
//     return this.day == now.day &&
//         this.month == now.month &&
//         this.year == now.year;
//   }
// }

String starPhoneNO(String phone) {
  String prefix = phone.substring(0, 3);
  String traling = phone.substring(9);
  return (prefix + '******' + traling);
}

String getFansCommand(int low, int high) {
  if (low == 0 && high == 0) return '不限';
  if (high == 0) {
    if (low < 10000)
      return '$low+';
    else
      return '${low ~/ 10000}W+';
  }

  ///区间数据
  String iLow = low.toString();
  if (low >= 10000) {
    int w = low ~/ 10000;
    iLow = '${w}W';
  }
  String iHigh = high.toString();
  if (high >= 10000) {
    int w = high ~/ 10000;
    iHigh = '${w}W';
  }
  return '$iLow—$iHigh';
}
