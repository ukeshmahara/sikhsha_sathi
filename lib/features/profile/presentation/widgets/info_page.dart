import 'package:flutter/material.dart';

const Color _kPrimaryBlue = Color(0xFF185FA5);

class InfoSection {
  final String heading;
  final String body;

  const InfoSection({required this.heading, required this.body});
}

class InfoPage extends StatelessWidget {
  final String title;
  final String? intro;
  final List<InfoSection> sections;

  const InfoPage({
    super.key,
    required this.title,
    this.intro,
    required this.sections,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: _kPrimaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (intro != null) ...[
              Text(
                intro!,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
            ],
            ...sections.map(
              (section) => Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.heading,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      section.body,
                      style: const TextStyle(fontSize: 13, height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}