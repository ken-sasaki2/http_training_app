import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? weatherText;

  Future<WeatherModel?>get() async {
    const lat = '35.65138';
    const lon = '139.63670';
    const key = 'aa50ce0598c22de20f75cf3ea31ac312';

    const domain = 'https://api.openweathermap.org';
    const pass = '/data/2.5/onecall';
    const query = '?lat=$lat&lon=$lon&exclude=daily&lang=ja&appid=$key';

    var url = Uri.parse(domain + pass + query);
    debugPrint('url: $url');

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var body = response.body;
      var decodeData = jsonDecode(body);
      var json = decodeData['current'];
      var model = WeatherModel.fromJson(json);

      return model;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    //

    return FutureBuilder(
      future: get(),
      builder: (BuildContext context, AsyncSnapshot<WeatherModel?> snapshot) {
        if (snapshot.hasData) {
          debugPrint('処理完了');
          debugPrint('data:${snapshot.data}');

          var data = snapshot.data;
          weatherText = data?.description;

          return Scaffold(
            body: Center(
                child: Text('現在の天気は$weatherTextです！')
            )
          );
        } else {
          debugPrint('処理中...');

          return const Scaffold(
              body: Center(
                  child: Text('処理中...')
              )
          );
        }
      }
    );
  }
}

class WeatherModel {
  final String main;
  final String description;
  final String icon;

  WeatherModel({
    required this.main,
    required this.description,
    required this.icon
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    var weather = json['weather'];
    var data = weather[0];

    var model = WeatherModel(
        main: data['main'],
        description: data['description'],
        icon: data['icon']
    );

    return model;
  }
}