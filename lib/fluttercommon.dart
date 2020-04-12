library fluttercommon;

import 'package:flutter/cupertino.dart';
import 'package:fluttercommon/api/api.dart';
import 'package:fluttercommon/api/api_result.dart';
import 'package:fluttercommon/utils/app_utils.dart';

/// A Calculator.
class FlutterCommon {
  static void init(BuildContext context,
      {double designWidth = 360,
      double designHeight = 640,
      String apiDomain,
      HttpType httpType = HttpType.http,
      String httpAuthType = HttpAuthType.basic}) {
    AppUtils(context, designWidth: designWidth, designHeight: designHeight);
    Api.httpType = httpType;
    Api.domain = apiDomain;
    Api.httpAuthType = httpAuthType;
  }

  static void setApiResultKeys(
      {String keyStatus = "status",
      String keyData = "data",
      String keyMessage = "msg"}) {
    ApiResult.keyData = keyData;
    ApiResult.keyMsg = keyMessage;
    ApiResult.keyStatus = keyStatus;
  }
}
