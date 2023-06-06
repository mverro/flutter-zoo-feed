import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildLoadingSkeleton() {
  return Scaffold(
    body: ListView.builder(
      itemCount: 3,
      itemBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 130,
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            enabled: true,
            child: Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Container(
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
        );
      },
    ),
  );
}
