import 'package:flutter/material.dart';
import 'package:news_app/home.dart';
import 'package:news_app/login.dart';
import 'package:news_app/splash.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/login': (context) => Login(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/home': (context) => HomePage(),
      },
      title: "News Application",
      home: SplashScreen(),
    );
  }
}
