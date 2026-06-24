import 'package:flutter/material.dart';

class SearchTab extends StatelessWidget {

  const SearchTab({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        'Search Schools',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}