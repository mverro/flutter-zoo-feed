import 'package:flutter/material.dart';

class smallcard extends StatelessWidget {
  final dynamic imageUrl;
  final dynamic text;
  final String destext;
  final double fontsize;

  const smallcard({
    super.key,
    required this.imageUrl,
    required this.text,
    required this.destext,
    this.fontsize = 45,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 150,
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: const Color(0xFFFB983E),
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: NetworkImage('http://13.55.144.244:3000/' + imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '${text}',
                  style: TextStyle(
                    fontSize: fontsize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.center,
              child: Text(
                destext,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
