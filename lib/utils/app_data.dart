import 'package:shared_preferences/shared_preferences.dart';

class AppData {
  static const base = "hethongphanhoi.com";
  static String keyAccessToken = "$base/keyAccessToken";
  static String keyUserType = "$base/keyUserType";
  static String keyFirebaseCloudMessageToken =
      "$base/keyFirebaseCloudMessageToken";
  static String keyTouchId = "$base/keyTouchId";

  static Future<bool> setAccessToken(String accessToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(keyAccessToken, accessToken);
  }

  static Future<String> getAccessToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyAccessToken);
  }

  static Future<bool> setStringValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<String> getStringValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> setBoolValue(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  static Future<bool> getBoolValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);

  }



}
