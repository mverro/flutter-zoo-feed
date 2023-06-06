import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/material.dart';
import 'package:zoo_feed/common/utils/coloors.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SpinKitFadingCube(
          color: Coloors.orange,
          size: 50.0,
        ),
      ),
    );
  }
}
