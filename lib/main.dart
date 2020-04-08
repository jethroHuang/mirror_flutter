import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:hive/hive.dart';
import 'package:mirror/appGlobal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory appPath = await getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  var box = await Hive.openBox(AppGlobal.BOX_KEY);
  AppGlobal.initUrl = box.get(AppGlobal.INIT_URL_KEY);
  SystemChrome.setEnabledSystemUIOverlays([]);
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '时钟容器',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AppGlobal.initUrl == null
          ? SetUrlPage()
          : WebviewScaffold(url: AppGlobal.initUrl),
    );
  }

  @override
  void initState() {
    Wakelock.enable();
    super.initState();
  }

  @override
  void dispose() {
    Wakelock.disable();
    super.dispose();
  }
}

class SetUrlPage extends StatefulWidget {
  @override
  _SetUrlPageState createState() => _SetUrlPageState();
}

class _SetUrlPageState extends State<SetUrlPage> {
  TextEditingController textCtl;

  @override
  Widget build(BuildContext context) {
    textCtl ??= TextEditingController();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 32),
          height: 250,
          child: ListView(
            children: <Widget>[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                color: Colors.white70,
                child: Text(
                  '网页URL',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.white38,
                child: TextField(
                  decoration: InputDecoration(hintText: '请输入需要打开的网页网址'),
                  controller: textCtl,
                  keyboardType: TextInputType.url,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white70),
                ),
              ),
              Container(
                color: Colors.white38,
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    FlatButton(
                        onPressed: saveUrl,
                        child: Text(
                          '保存',
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 保存url
  void saveUrl() {
    AppGlobal.initUrl = textCtl.text;
    Hive.box(AppGlobal.BOX_KEY).put(AppGlobal.INIT_URL_KEY, textCtl.text);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => WebviewScaffold(url: AppGlobal.initUrl)));
  }
}
