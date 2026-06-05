import 'package:flutter/material.dart';

class SchoolCard extends StatelessWidget {

  final String image;
  final String title;
  final String location;

  const SchoolCard({
    super.key,
    required this.image,
    required this.title,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {

    return Container(

      width: 180,

      margin: const EdgeInsets.only(right: 15),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),

        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 5,
          ),
        ],
      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          ClipRRect(

            borderRadius:
            const BorderRadius.vertical(
              top: Radius.circular(15),
            ),

            child: Image.asset(
              image,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  location,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}