import 'package:flutter/material.dart';

import 'package:sikhsha_sathi/features/profile/presentation/widgets/info_page.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'Terms of Service',
      intro:
          'By creating an account and using Sikhsha Sathi, you agree to the terms '
          'below. Please read them carefully.',
      sections: [
        InfoSection(
          heading: 'Your account',
          body:
              'You are responsible for keeping your login credentials secure and for '
              'all activity under your account. If you enable fingerprint login, you are '
              'responsible for controlling who has fingerprint access to your device.',
        ),
        InfoSection(
          heading: 'School information accuracy',
          body:
              'School details such as fees, facilities, and contact information are '
              'provided by school administrators or added by our team. While we aim for '
              'accuracy, we recommend confirming important details (fees, admission '
              'deadlines, facilities) directly with the school before making decisions.',
        ),
        InfoSection(
          heading: 'AI recommendations are suggestions only',
          body:
              'AI-generated school recommendations are intended to help you narrow down '
              'options based on your stated preferences. They are not guarantees of '
              'admission, fit, or accuracy, and should not replace your own research or '
              'direct communication with schools.',
        ),
        InfoSection(
          heading: 'Reviews and ratings',
          body:
              'Reviews must reflect your genuine experience or knowledge of a school. Do '
              'not post false, misleading, defamatory, or abusive content. We reserve the '
              'right to remove reviews that violate these guidelines.',
        ),
        InfoSection(
          heading: 'Asking schools questions',
          body:
              'The Inquiry feature is meant for genuine questions about admissions, fees, '
              'facilities, and similar topics. Please do not use it to send spam, abusive '
              'messages, or unrelated content to schools.',
        ),
        InfoSection(
          heading: 'Acceptable use',
          body:
              'You agree not to misuse the app, attempt to access other users\' accounts, '
              'interfere with the app\'s normal operation, or use the app for any unlawful '
              'purpose.',
        ),
        InfoSection(
          heading: 'Changes to the service',
          body:
              'We may update, modify, or discontinue features of the app at any time. We '
              'will make reasonable efforts to notify users of significant changes '
              'through the app\'s Notifications feature.',
        ),
        InfoSection(
          heading: 'Termination',
          body:
              'We may suspend or terminate accounts that violate these terms, including '
              'posting false reviews or misusing the Inquiry feature.',
        ),
        InfoSection(
          heading: 'Contact us',
          body:
              'Questions about these Terms of Service can be sent to '
              'legal@sikhshasathi.com.',
        ),
      ],
    );
  }
}