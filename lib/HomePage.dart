import 'dart:convert';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:jake_git/Shared_prefs/Shared_preference.dart';
import 'package:jake_git/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();
  List<String> name = [];
  List<String> Description = [];
  List<String> language = [];
  List<String> watchers_count = [];
  List<String> open_isuues = [];
  List<String> Sharedname = [];
  List<String> SharedDesc = [];
  List<String> SharedLang = [];
  List<String> SharedWatchers = [];
  List<String> SharedIssues = [];

  bool _isLoading = false;
  bool allLoaded = false;
  bool _isInternetConnected = true;
  Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      var res = await result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      setState(() {
        _isInternetConnected = res;
      });

      return res;
    } on SocketException catch (_) {
      setState(() {
        _isInternetConnected = false;
      });

      return false;
    }
  }

  getList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoading = true;
    });
    try {
      var value;
      String url =
          "https://api.github.com/users/JakeWharton/repos?page=1&per_page=60";
      var response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      // print('Response body: ${response.body}');
      setState(() {
        value = json.decode(response.body);
      });

      if (response.statusCode == 200) {
        if (value != null) {
          List<String> newNameData = name.length >= value.length
              ? []
              : List.generate(
                  15, (index) => value[name.length + index]["name"].toString());
          List<String> newLanguageData = name.length >= value.length
              ? []
              : List.generate(15,
                  (index) => value[name.length + index]["language"].toString());
          List<String> newWatcherCountData = name.length >= value.length
              ? []
              : List.generate(
                  15,
                  (index) =>
                      value[name.length + index]["watchers_count"].toString());
          List<String> newOpenIssuesData = name.length >= value.length
              ? []
              : List.generate(
                  15,
                  (index) =>
                      value[name.length + index]["open_issues"].toString());
          List<String> newDescriptionData = name.length >= value.length
              ? []
              : List.generate(
                  15,
                  (index) =>
                      value[name.length + index]["description"].toString());
          // print(value.length);
          prefs.setStringList("nameList", newNameData);
          prefs.setStringList("langList", newLanguageData);
          prefs.setStringList("watchersCount", newWatcherCountData);
          prefs.setStringList("openIssues", newOpenIssuesData);
          prefs.setStringList("DescriptionList", newDescriptionData);
          setState(() {
            name.addAll(newNameData);
            language.addAll(newLanguageData);
            watchers_count.addAll(newWatcherCountData);
            open_isuues.addAll(newOpenIssuesData);
            Description.addAll(newDescriptionData);
          });

          setState(() {
            _isLoading = false;
            allLoaded = newNameData.isEmpty;
          });
        } else {
          Fluttertoast.showToast(msg: "Please check your internet Connection");
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => FingerPrintApp()));
        }
      } else {
        Fluttertoast.showToast(msg: "Please check your internet Connection");
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FingerPrintApp()));
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    isInternetConnected().then((value) {
      setState(() {
        _isInternetConnected = value;
      });
      if (value == true) {
        getList();
        _scrollController.addListener(() {
          if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent) {
            print("new data call");
            getList();
          }
        });
      } else {
        checkinSharedpf();
      }
    });
  }

  checkinSharedpf() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> localnameList = await prefs.getStringList("nameList");
    List<String> locallanguage = await prefs.getStringList("langList");
    List<String> localwatchers_count =
        await prefs.getStringList("watchersCount");
    List<String> localopen_isuues = await prefs.getStringList("openIssues");
    List<String> localDescription =
        await prefs.getStringList("DescriptionList");

    if (localnameList != [] &&
        localDescription != [] &&
        locallanguage != [] &&
        localwatchers_count != [] &&
        localopen_isuues != []) {
      setState(() {
        name.addAll(localnameList);
        Description.addAll(localDescription);
        language.addAll(locallanguage);
        watchers_count.addAll(localwatchers_count);
        open_isuues.addAll(localopen_isuues);
      });
    } else {
      Fluttertoast.showToast(msg: "Please check your internet Connection");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => FingerPrintApp()));
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Color(0xff3c3e52),
          title: Center(child: Text("Jake's Git")),
        ),
        body: name.isEmpty == true
            ? Center(
                child: CircularProgressIndicator(),
              )
            : LayoutBuilder(builder: (context, constraints) {
                return Stack(children: [
                  ListView.builder(
                    controller: _scrollController,
                    //physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: name.length + (allLoaded ? 1 : 0),
                    itemBuilder: (BuildContext ctx, int i) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 30),
                        child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              // border: Border.all(
                              //     color: Colors.black,
                              //     width: 1,
                              //     style: BorderStyle.solid)),
                            ),
                            child: i < name.length
                                ? ListTile(
                                    leading: Icon(
                                      Icons.book_rounded,
                                      size: 50,
                                      color: Colors.black,
                                    ),
                                    title: Text(name[i]),
                                    subtitle: Container(
                                      child: Column(
                                        children: [
                                          Text(Description[i]),
                                          Row(
                                            children: [
                                              Icon(Icons.ac_unit_rounded),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(language[i]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Icon(
                                                    Icons.bug_report_sharp),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(open_isuues[i]),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Icon(Icons.person),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5),
                                                child: Text(watchers_count[i]),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    width: constraints.maxWidth,
                                    height: 50,
                                    child: Center(
                                      child:
                                          Text("This is the end of the List"),
                                    ),
                                  )),
                      );
                    },
                  ),
                  if (_isLoading) ...[
                    Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          // color: Colors.white,
                          width: constraints.maxWidth,
                          height: 30,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ))
                  ]
                ]);
              }));
  }
}
