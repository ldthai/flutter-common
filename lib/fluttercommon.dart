library fluttercommon;

import 'package:flutter/cupertino.dart';
import 'package:fluttercommon/api/api.dart';
import 'package:fluttercommon/utils/app_utils.dart';

/// A Calculator.
class FlutterCommon {
  static void init(BuildContext context,
      {double designWidth,
      double designHeight,
      String apiDomain,
      HttpType httpType = HttpType.http,
      String httpAuthType = HttpAuthType.basic}) {
    AppUtils(context, designWidth: designWidth, designHeight: designHeight);
    Api.httpType = httpType;
    Api.domain = apiDomain;
    Api.httpAuthType = httpAuthType;
  }
}
