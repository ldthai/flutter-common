import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';

import 'api.dart';

class ApiResult<T> {
  int status;
  String _msg;
  T data;
  DataType dataType;

  ApiResult(
      {this.status = 0,
      String msg = "Lỗi kết nối, vui lòng thử lại",
      this.data,
      this.dataType = DataType.Object}) {
    this._msg = msg;
  }

  factory ApiResult.fromResponse(Response response, {DecodeData decodeData}) {
    ApiResult<T> apiResult = ApiResult<T>();
    try {
      if (response != null &&
          response.statusCode == 200 &&
          response.body != null) {
        Map<String, dynamic> result = json.decode(response.body);
        if (result != null) {
          try {
            apiResult =
                ApiResult<T>(status: result["status"], msg: result["msg"]);
          } catch (e) {
            debugPrint("$e");
          }
          try {

            if (decodeData != null && result["data"] != null) {
              apiResult.data = decodeData(result["data"]);
            }
          } catch (e) {
            debugPrint("$e");
          }
        }
      }
    } catch (e) {
      debugPrint("$e");
    }
    return apiResult;
  }

  String get msg {
    if (_msg != null) return _msg;
    return "";
  }

  set msg(String value) {
    _msg = value;
  }
}

enum DataType { Object, List }
