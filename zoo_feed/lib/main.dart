import 'package:flutter/material.dart';
import 'package:zoo_feed/features/welcome/pages/splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zoo Feed',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: SplashPage(),
    );
  }
}
