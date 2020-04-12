import 'dart:io';

import 'package:clipboard_manager/clipboard_manager.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttercommon/api/api_result.dart';
import 'package:html/parser.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static AppUtils instance;
  static BuildContext globalContext;
  static GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey();
  double designWidth;
  double designHeight;
  bool allowFontScaling = false;
  double screenWidth;
  double screenHeight;
  double pixelRatio;
  double statusBarHeight;
  double bottomBarHeight;
  double textScaleFactor;
  double scaleX, scaleY, scale;

  AppUtils(BuildContext context, {this.designWidth, this.designHeight}) {
    if (AppUtils.globalContext == null) AppUtils.globalContext = context;
    if (AppUtils.instance != null &&
        (this.designWidth == null || this.designHeight == null)) {
      this.designWidth = AppUtils.instance.designWidth;
      this.designHeight = AppUtils.instance.designHeight;
    }
    AppUtils.instance = this;
    MediaQueryData mediaQuery = MediaQuery.of(context);
    pixelRatio = mediaQuery.devicePixelRatio;
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    statusBarHeight = mediaQuery.padding.top;
    bottomBarHeight = mediaQuery.padding.bottom;
    textScaleFactor = mediaQuery.textScaleFactor;

    scaleX = screenWidth / designWidth;

    scaleY = screenHeight / designHeight;

    scale = scaleX < scaleY ? scaleX : scaleY;
  }

  static AppUtils getInstance() {
    return instance;
  }

  double get safeHeight => screenHeight - statusBarHeight - bottomBarHeight;

  double get bodyHeight =>
      screenHeight -
      statusBarHeight -
      bottomBarHeight -
      AppBar().preferredSize.height;

  double get paddingHorizontal => 14.4 * scale;

  static String formatMoney(int money) {
    if (money != null)
      return "${NumberFormat(",###", "vi").format(money)}đ";
    else
      return "0đ";
  }

  static String formatNumber(dynamic money) {
    if (money != null) if (money > 999)
      return "${NumberFormat(",###", "vi").format(money)}";
    else
      return "$money";
    else
      return "0";
  }

  static String getDayOfWeek(DateTime date) {
    List<String> dayOfWeeks = [
      "Thứ hai",
      "Thứ ba",
      "Thứ tư",
      "Thứ năm",
      "Thứ sáu",
      "Thứ bảy",
      "Chủ nhật"
    ];
    return dayOfWeeks[date.weekday] ?? null; // thu trong tuan
  }

  static String getVietnameseDate(DateTime date) {
    return ""; // thu trong tuan
  }

  String getLogTime(String date) {
    DateTime dt = new DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
    return new DateFormat("dd/MM/yyyy").format(dt) +
        " " +
        formatHour(dt) +
        ":" +
        formatMinute(dt);
  }

  String formatHour(DateTime time) {
    if (time != null)
      return DateFormat("HH").format(time);
    else
      return "00";
  }

  String formatMinute(DateTime time) {
    if (time != null)
      return DateFormat("mm").format(time);
    else
      return "00";
  }

  static String formatMoneyShort(int money) {
    if (money < 1000) {
      return "${money} Đ";
    } else if (money < 1000000) {
      return "${(money % 1000 == 0 ? (money / 1000).toInt() : (money / 1000))} Ngàn";
    } else if (money < 1000000000) {
      return "${(money % 1000000 == 0 ? (money / 1000000).toInt() : (money / 1000000))} Triệu";
    } else {
      return "${(money % 1000000000 == 0 ? (money / 1000000000).toInt() : (money / 1000000000))} Tỷ";
    }
  }

  String parseHtmlString(String htmlString) {
    try {
      var document = parse(htmlString);

      String parsedString = parse(document.body.text).documentElement.text;

      return parsedString;
    } catch (e) {
      return "";
    }
  }

  static String hidePhone(String phone) {
    if (phone != null && phone.length > 6) {
      String s1 = phone.substring(0, phone.length - 6);
      String s3 = phone.substring(phone.length - 3);
      return "$s1***$s3";
    }
    return phone;
  }

  static String hideEmail(String email) {
    debugPrint("$email");
    if (email == null) return "";
    try {
      if (email != null && email.contains("@")) {
        String str1 = email.substring(0, email.lastIndexOf("@"));
        String str2 = email.substring(email.lastIndexOf("@"));
        if (str1.length > 3) {
          return "${str1.substring(0, str1.length - 3)}***$str2";
        } else {
          return "***$str2";
        }
      } else
        return email;
    } catch (e) {
      debugPrint("$e");
    }
    return email;
  }

  static showApiResultToast(BuildContext context, ApiResult apiResult) {
    if (apiResult.status == 1) {
      Toast.show("Thành công", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    } else {
      if (apiResult.msg != null && apiResult.msg.length > 0) {
        Toast.show("${apiResult.msg}", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      } else {
        Toast.show("Lỗi, vui lòng thử lại", context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      }
    }
  }

  static Future<http.MultipartFile> createMultipartFile(
      String fieldName, File file) async {
    try {
      var name =
          file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
      final mimeTypeData =
          lookupMimeType(file.path, headerBytes: [0xFF, 0xD8]).split('/');
      final multipartFile = await http.MultipartFile.fromPath(
          fieldName, file.path,
          contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
          filename: name);
      return multipartFile;
    } catch (e) {
      debugPrint("$e");
      return null;
    }
  }

  static getFileName(File file) {
    var name = "";
    try {
      name =
          file.path.substring(file.path.lastIndexOf("/") + 1, file.path.length);
    } catch (e) {}
    return name;
  }

  static showToast(String text, BuildContext context) {
    Toast.show("$text", context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  }

  static copyToClipBoard(BuildContext context, String text) {
    ClipboardManager.copyToClipBoard("$text").then((result) {
      AppUtils.showToast("Copied to Clipboard", context);
    });
  }

  static String bestAppBarTitle(String title) {
    try {
      if (title != null && title.contains(" ")) {
        List<String> list = title.split(" ");
        if (list != null && list.length > 2) {
          int tempIndex = (list.length / 2).toInt();
          String str = "";
          for (int i = 0; i < list.length; i++) {
            if (i == tempIndex)
              str += "\n";
            else if (i > 0) str += " ";
            str += list[i];
          }
          return str;
        }
        return title;
      }
      return title;
    } catch (e) {
      debugPrint("$e");
    }
    return "$title";
  }

  static buildAppBar(BuildContext context, {String title = ""}) {
    return AppBar(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.normal)),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 0.0,
    );
  }

  static buildLine() {
    return Container(
        width: double.maxFinite,
        height: 10.5 * AppUtils.getInstance().scale,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [const Color(0xfff9f9f9), const Color(0xffeeeeee)])));
  }

  static buildLineMini() {
    return Container(
        width: double.maxFinite,
        height: 2 * AppUtils.getInstance().scale,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [const Color(0xfff9f9f9), const Color(0xffeeeeee)])));
  }

  static showDialogDatePicker(
      BuildContext context, OnDateCallback onDateCallback,
      {DateTime initValue}) {
    Picker(
            hideHeader: true,
            backgroundColor: Colors.white,
            containerColor: Colors.white,
            adapter: DateTimePickerAdapter(
                type: PickerDateTimeType.kDMY,
                value: initValue != null ? initValue : DateTime.now(),
                isNumberMonth: true),
            title: Text("Chọn ngày"),
            cancel: Padding(
                padding: EdgeInsets.only(right: 10),
                child: Text(
                  "Huỷ",
                  style: TextStyle(color: Theme.of(context).primaryColor),
                )),
            confirm: Text(
              "Hoàn thành",
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            columnPadding: const EdgeInsets.all(5.0),
            selectedTextStyle: TextStyle(color: Colors.black),
            onConfirm: (Picker picker, List value) {
              onDateCallback((picker.adapter as DateTimePickerAdapter).value);
            })
        .showDialog(context,
            contentPadding: EdgeInsets.symmetric(vertical: 0),
            titlePadding: EdgeInsets.only(left: 24, top: 10));
  }

  static showConfirmDialog(BuildContext context, String title,
      {String ok = "Đồng ý", String cancel = "Huỷ"}) async {
    return await showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: GestureDetector(
                    onTap: () {},
                    child: Center(
                        child: Container(
                      margin: EdgeInsets.symmetric(
                          horizontal: 30 * AppUtils.getInstance().scaleX),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              10 * AppUtils.getInstance().scale)),
                      padding: EdgeInsets.symmetric(
                          vertical: 25 * AppUtils.getInstance().scale),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "$title",
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 20 * AppUtils.getInstance().scaleX,
                          ),
                          Container(
                            width: double.maxFinite,
                            height: 1,
                            color: Colors.black54,
                          ),
                          SizedBox(
                            height: 20 * AppUtils.getInstance().scaleX,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(
                                width: 25 * AppUtils.getInstance().scaleX,
                              ),
                              Expanded(
                                child: GestureDetector(
                                    onTap: () => Navigator.pop(context, true),
                                    child: Container(
                                      width: double.maxFinite,
                                      padding:
                                          EdgeInsets.symmetric(vertical: 10),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4)),
                                          color:
                                              Theme.of(context).primaryColor),
                                      child: Text(
                                        "$ok",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 17),
                                      ),
                                    )),
                              ),
                              SizedBox(
                                width: 25 * AppUtils.getInstance().scaleX,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                      onTap: () =>
                                          Navigator.pop(context, false),
                                      child: Container(
                                        width: double.maxFinite,
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(4)),
                                            color:
                                                Theme.of(context).primaryColor),
                                        child: Text(
                                          "$cancel",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 17),
                                        ),
                                      ))),
                              SizedBox(
                                width: 25 * AppUtils.getInstance().scaleX,
                              ),
                            ],
                          )
                        ],
                      ),
                    ))),
              ));
        });
  }

  static Future<LocationData> getLocation() async {
    LocationData locationData;
    try {
      var location = new Location();
      locationData = await location.getLocation();
    } catch (e) {
      if (e.code == 'PERMISSION_DENIED') {}
      locationData = null;
    }
    return locationData;
  }

  static Future<String> getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    } else
      return "";
  }

  static launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

typedef OnDateCallback(DateTime value);
