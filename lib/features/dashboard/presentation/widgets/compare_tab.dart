import 'package:flutter/material.dart';

class CompareTab extends StatelessWidget {

  const CompareTab({super.key});

  @override
  Widget build(BuildContext context) {

    return const Center(
      child: Text(
        'Compare Schools',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}