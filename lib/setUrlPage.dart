import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:mirror/main.dart';

import 'appGlobal.dart';
import 'main.dart';

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
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  AppGlobal.initUrl,
                )));
  }
}
