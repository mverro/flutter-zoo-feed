import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedTitleWidget extends StatefulWidget {
  final dynamic username;

  const AnimatedTitleWidget({required this.username});

  @override
  _AnimatedTitleWidgetState createState() => _AnimatedTitleWidgetState();
}

class _AnimatedTitleWidgetState extends State<AnimatedTitleWidget> {
  late List<String> titles;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    titles = [
      'Hello, ${widget.username} !',
      'Selamat Datang di ZooFeed',
      'Explore lagi keseruan',
      'Explore Animals',
      'Explore Habitat',
      'Explore Classification'
    ];
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        currentIndex = (currentIndex + 1) % titles.length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Text(
        titles[currentIndex],
        key: ValueKey<String>(titles[currentIndex]),
        style: const TextStyle(
          fontSize: 15,
          fontFamily: "inter",
        ),
      ),
    );
  }
}
