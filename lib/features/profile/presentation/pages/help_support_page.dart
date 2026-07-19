import 'package:flutter/material.dart';

import 'package:sikhsha_sathi/features/profile/presentation/widgets/info_page.dart';

class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const InfoPage(
      title: 'Help & Support',
      intro:
          'Find answers to common questions about using Sikhsha Sathi. '
          'If you need more help, reach out to us using the contact details at the bottom.',
      sections: [
        InfoSection(
          heading: 'Searching for schools',
          body:
              'Use the Search tab to look up schools by name, or filter by category '
              '(International, Public, Private, Budget friendly), stream (Science, '
              'Management, Humanities), fee range, and sort order. The Home tab also '
              'shows a quick category overview with live counts.',
        ),
        InfoSection(
          heading: 'Comparing schools',
          body:
              'Open the Compare tab, tap a slot to pick a school, then pick a second '
              'one. You\'ll see a side-by-side breakdown of location, category, annual '
              'fee, streams offered, and facilities, with the cheaper option highlighted.',
        ),
        InfoSection(
          heading: 'Saving favourites',
          body:
              'Tap the heart icon on any school card or on a School Detail page to save '
              'it to your Favourites tab. Favourites sync with your account, so they\'re '
              'the same whether you use this app or the Sikhsha Sathi website.',
        ),
        InfoSection(
          heading: 'AI school recommendations',
          body:
              'From the Home tab, tap "AI school recommendation" and tell us your '
              'preferred stream, budget, and any preferences. Our AI reviews real schools '
              'in our database and ranks the best matches for you, with a short reason '
              'for each. Results are suggestions to help narrow your search, not guarantees.',
        ),
        InfoSection(
          heading: 'Writing a review',
          body:
              'On any School Detail page, scroll to the Reviews section and tap "Write a '
              'review" to rate the school 1-5 stars with a comment. You can edit or delete '
              'your own review at any time. Please keep reviews honest and respectful.',
        ),
        InfoSection(
          heading: 'Asking a school a question',
          body:
              'Tap "Ask this school" on a School Detail page to send a question directly '
              'to that school. You\'ll see their response (if any) right on the same page '
              'once they reply — pull down to refresh and check for new responses.',
        ),
        InfoSection(
          heading: 'Fingerprint login',
          body:
              'After logging in with your password at least once, you can enable '
              'fingerprint login from this Profile page. This lets you unlock your '
              'existing session with your fingerprint instead of typing your password '
              'every time — it doesn\'t create a new account or bypass your password entirely.',
        ),
        InfoSection(
          heading: 'Using the app offline',
          body:
              'Your favourites and notifications are cached on your device, so you can '
              'still view them without an internet connection. Actions like adding a new '
              'favourite, submitting a review, or asking a question require an internet '
              'connection since they need to reach our servers.',
        ),
        InfoSection(
          heading: 'Contact us',
          body:
              'For anything not covered here, email us at support@sikhshasathi.com and '
              'we\'ll get back to you as soon as we can.',
        ),
      ],
    );
  }
}