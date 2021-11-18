import 'package:shared_preferences/shared_preferences.dart';

class Shared_prefs {
  static List<String> SharedPrefsName = [];
  static List<String> SharedPrefsDesc = [];
  static List<String> language = [];
  static List<String> watchers_count = [];
  static List<String> open_isuues = [];
  static Future<bool> saveNameDetails(List<String> nameList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setStringList('SharedPrefsName', nameList);
  }

  static Future<bool> saveDescDetails(List<String> descList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setStringList('SharedPrefsDesc', descList);
  }

  static Future<bool> saveLangDetails(List<String> langList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setStringList('language', langList);
  }

  static Future<bool> saveWatchersDetails(List<String> watchersList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setStringList('watchers_count', watchersList);
  }

  static Future<bool> saveIssuesDetails(List<String> issueList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return await prefs.setStringList('open_isuues', issueList);
  }

  static Future<List<String>> getNameList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('SharedPrefsName');
  }

  static Future<List<String>> getDescList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('SharedPrefsDesc');
  }

  static Future<List<String>> getLanguageList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('language');
  }

  static Future<List<String>> getWatchersList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('watchers_count');
  }

  static Future<List<String>> getIssuesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('open_isuues');
  }
}
