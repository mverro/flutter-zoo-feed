import 'package:flutter/material.dart';

class AnimalLikedItem extends StatelessWidget {
  final String image;
  final String name;
  const AnimalLikedItem({
    super.key,
    required this.image,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 50,
          margin: const EdgeInsets.only(left: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: NetworkImage('http://13.55.144.244:3000/$image'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: 60,
          child: Text(
            name,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
