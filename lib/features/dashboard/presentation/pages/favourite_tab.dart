import 'package:flutter/material.dart';

class FavouriteTab extends StatelessWidget {

  const FavouriteTab({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        'Favourite Schools',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}