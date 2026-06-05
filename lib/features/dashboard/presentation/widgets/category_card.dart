import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {

  final String image;
  final String title;
  final Color color;

  const CategoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {

    return Column(

      children: [

        Container(

          padding: const EdgeInsets.all(18),

          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),

          child: Image.asset(
            image,
            width: 30,
            height: 30,
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: 70,

          child: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}