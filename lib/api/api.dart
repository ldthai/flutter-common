import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttercommon/utils/app_data.dart';
import 'package:http/http.dart';

typedef dynamic DecodeData(dynamic json);

enum HttpType { http, https }

class HttpAuthType {
  static const String basic = "Basic";
  static const String bearer = "Bearer";
}

class Api {
  static String domain;
  static HttpType httpType = HttpType.http;
  static String httpAuthType = HttpAuthType.basic;

  static Future<Response> get(String link, {Map<String, String> params}) async {
    Response response = null;
    try {
      String token = await AppData.getAccessToken();
      if (params != null) debugPrint(json.encode(params));
      debugPrint("$link");
      debugPrint("$token");

      if (token != null && token.length > 0)
        response = await Client().get(
            link.contains("http", 0)
                ? link
                : (httpType == HttpType.http
                    ? Uri.http(domain, link, params)
                    : Uri.https(domain, link, params)),
            headers: {HttpHeaders.authorizationHeader: "$httpAuthType $token"});
      else
        response = await Client().get(
          link.contains("http", 0)
              ? link
              : (httpType == HttpType.http
                  ? Uri.http(domain, link, params)
                  : Uri.https(domain, link, params)),
        );
      if (response != null) {
        debugPrint("${response.body}", wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint("$e");
    }
    return response;
  }

  static Future<Response> post(String link, {Map params}) async {
    Response response = null;
    try {
      String token = await AppData.getAccessToken();
      debugPrint("$token");
      debugPrint("$link");
      if (params != null) debugPrint(json.encode(params));

      if (token != null && token.length > 0)
        response = await Client().post(
            (httpType == HttpType.http
                ? Uri.http(domain, link)
                : Uri.https(domain, link)),
            body: params != null ? json.encode(params) : null,
            headers: {
              HttpHeaders.authorizationHeader: "$httpAuthType $token",
              "Content-Type": "application/json"
            });
      else
        response = await Client().post(
          (httpType == HttpType.http
              ? Uri.http(domain, link)
              : Uri.https(domain, link)),
          headers: {"Content-Type": "application/json"},
          body: params != null ? json.encode(params) : null,
        );
      if (response != null) {
        debugPrint("${json.encode(json.decode(response.body))}",
            wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint("$e");
    }
    return response;
  }

  static Future<Response> put(String link,
      {Map<String, dynamic> params}) async {
    debugPrint("$link");
    debugPrint("$params");
    Response response = null;
    try {
      String token = await AppData.getAccessToken();

      if (token != null && token.length > 0)
        response = await Client().put(
            (httpType == HttpType.http
                ? Uri.http(domain, link)
                : Uri.https(domain, link)),
            body: params,
            headers: {HttpHeaders.authorizationHeader: "$httpAuthType $token"});
      else
        response = await Client().put(
          (httpType == HttpType.http
              ? Uri.http(domain, link)
              : Uri.https(domain, link)),
          body: params,
        );
      if (response != null) {
        debugPrint("${response.body}", wrapWidth: 1024);
      }
    } catch (e) {
      debugPrint("$e");
    }
    return response;
  }

  static Future<Response> delete(String link,
      {Map<String, String> params}) async {
    String token = await AppData.getAccessToken();
    if (token != null && token.length > 0) {
      return await Client().delete(
          (httpType == HttpType.http
              ? Uri.http(domain, link, params)
              : Uri.https(domain, link, params)),
          headers: {HttpHeaders.authorizationHeader: "$httpAuthType $token"});
    } else
      return await Client().delete(httpType == HttpType.http
          ? Uri.http(domain, link, params)
          : Uri.https(domain, link, params));
  }

  static BuildContext mainContext;

  static setContext(BuildContext context) {
    mainContext = context;
  }

  static Future<Response> postMutiplePart(String link,
      {List<MultipartFile> files, Map<String, String> params}) async {
    try {
      if (params != null) debugPrint("$params");

      final request = MultipartRequest(
          "POST",
          (httpType == HttpType.http
              ? Uri.http(domain, link)
              : Uri.https(domain, link)));
      String token = await AppData.getAccessToken();
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "$httpAuthType $token",
        "Content-Type": "multipart/form-data"
      };
      request.headers.addAll(headers);
      if (params != null) request.fields.addAll(params);
      if (files != null) request.files.addAll(files);

      final streamedResponse = await request.send();
      Response response = null;
      if (streamedResponse != null)
        response = await Response.fromStream(streamedResponse);
      if (response != null) {
        debugPrint("${response.body}");
      }
      return response;
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }

  static Future<Response> putMutiplePart(String link,
      {List<MultipartFile> files, Map<String, String> params}) async {
    try {
      final request = MultipartRequest(
          "PUT",
          (httpType == HttpType.http
              ? Uri.http(domain, link)
              : Uri.https(domain, link)));
      String token = await AppData.getAccessToken();
      Map<String, String> headers = {
        HttpHeaders.authorizationHeader: "$httpAuthType $token",
        "Content-Type": "multipart/form-data"
      };
      request.headers.addAll(headers);
      if (params != null) request.fields.addAll(params);
      if (files != null) request.files.addAll(files);
      final streamedResponse = await request.send();
      Response response = null;
      if (streamedResponse != null)
        response = await Response.fromStream(streamedResponse);
      if (response != null) {
        debugPrint("${response.body}");
      }
      return response;
    } catch (e) {
      debugPrint("$e");
    }
    return null;
  }
}
