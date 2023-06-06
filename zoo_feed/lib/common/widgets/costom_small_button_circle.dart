import 'package:flutter/material.dart';
import '../../../common/utils/coloors.dart';

class CustomSmallButtonCircle extends StatelessWidget {
  final IconData iconData;
  final VoidCallback onPressed;

  const CustomSmallButtonCircle({
    required this.iconData,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      child: AspectRatio(
        aspectRatio: 1.1,
        child: Container(
          decoration: const BoxDecoration(
            color: Coloors.green,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: IconButton(
              icon: Icon(
                iconData,
                color: Colors.white,
              ),
              onPressed: onPressed,
            ),
          ),
        ),
      ),
    );
  }
}
