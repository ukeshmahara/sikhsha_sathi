import 'package:flutter/material.dart';

import 'package:sikhsha_sathi/features/profile/presentation/widgets/info_page.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'Privacy Policy',
      intro:
          'This policy explains what information Sikhsha Sathi collects, how it\'s used, '
          'and the choices you have. Last updated: 2026.',
      sections: [
        InfoSection(
          heading: 'Information we collect',
          body:
              'When you create an account, we collect your full name, email address, '
              'phone number, and (if you choose to add one) a profile picture. When you '
              'use the app, we also store the schools you favourite, any reviews you '
              'write, and any questions you send to schools through the app.',
        ),
        InfoSection(
          heading: 'Fingerprint and biometric login',
          body:
              'If you enable fingerprint login, your fingerprint data never leaves your '
              'device and is never sent to our servers. It is verified entirely by your '
              'phone\'s own operating system. We only store a simple on/off preference '
              'that fingerprint login is enabled for your account on that device.',
        ),
        InfoSection(
          heading: 'AI recommendations and third-party services',
          body:
              'When you request an AI school recommendation, the preferences you enter '
              '(stream, budget, location, notes) are sent to Google\'s Gemini AI service '
              'to generate suggestions. We do not send your name, email, or other '
              'personal account details as part of this request — only your stated '
              'preferences and general school information already in our database.',
        ),
        InfoSection(
          heading: 'How we use your information',
          body:
              'We use your information to operate your account, show you personalized '
              'features like favourites and recommendations, let schools respond to your '
              'inquiries, and improve the app. We do not sell your personal information '
              'to third parties.',
        ),
        InfoSection(
          heading: 'Data storage',
          body:
              'Your account data is stored securely on our servers. Some information, '
              'such as your favourites and recent notifications, is also cached locally '
              'on your device so the app can show it to you even when you\'re offline.',
        ),
        InfoSection(
          heading: 'Reviews and public content',
          body:
              'Reviews you submit, including your name and rating, are visible to other '
              'users viewing that school\'s page. Questions you send to a school through '
              'the Inquiry feature are visible to that school\'s admin, along with their '
              'reply to you.',
        ),
        InfoSection(
          heading: 'Your choices',
          body:
              'You can update your profile information, delete your own reviews, and '
              'disable fingerprint login at any time from your Profile page. Logging out '
              'clears your session and any locally cached data from that device.',
        ),
        InfoSection(
          heading: 'Contact us',
          body:
              'If you have questions about this Privacy Policy or how your data is '
              'handled, contact us at privacy@sikhshasathi.com.',
        ),
      ],
    );
  }
}