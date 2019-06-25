import 'package:counting/counting_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() =>
    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeRight])
        .then((_) {
      runApp(MaterialApp(home: MyApp()));
    });

class MyApp extends StatefulWidget {
  CountingState createState() => CountingState();
}

class CountingState extends State<MyApp> {
  bool pause = false;
  MediaQueryData queryData;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Center(
            child: CountingGame()));
  }
}
