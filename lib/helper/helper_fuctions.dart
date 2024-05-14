import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String prefUserLogIn ="ISUSERLOGIN";
  static String prefUserName ="USERNAME";
  static String prefUserEmail ="USEREMAIL";

  //setData
  static Future<bool> setStringData(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setString(key, value);
  }

  static Future<bool> setBooleanData(String key, bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.setBool(key, value);
  }

  //getData
  static Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool?> getBoolean(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static removeString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
