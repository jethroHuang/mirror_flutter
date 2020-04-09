import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:hive/hive.dart';
import 'package:mirror/appGlobal.dart';
import 'package:mirror/setUrlPage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wakelock/wakelock.dart';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);
  Directory appPath = await getApplicationDocumentsDirectory();
  Hive.init(appPath.path);
  var box = await Hive.openBox(AppGlobal.BOX_KEY);
  AppGlobal.initUrl = box.get(AppGlobal.INIT_URL_KEY);
  if (Platform.isAndroid) {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    var info = await deviceInfo.androidInfo;
    AppGlobal.androidAPiLevel = info.version.sdkInt;
  }

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
          backgroundColor: Colors.black,
          brightness: Brightness.dark),
      home: AppGlobal.initUrl == null
          ? SetUrlPage()
          : HomePage(AppGlobal.initUrl),
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

class HomePage extends StatelessWidget {
  final String url;

  HomePage(this.url, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  getBody() {
    if (Platform.isAndroid && AppGlobal.androidAPiLevel < 21) {
      return WebviewScaffold(
        url: url,
        withZoom: true,
        withJavascript: true,
      );
    } else {
      return WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
      );
    }
  }
}
