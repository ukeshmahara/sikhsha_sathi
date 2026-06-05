import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/bottom_nav_provider.dart';

import '../widgets/home_tab.dart';
import '../widgets/search_tab.dart';
import '../widgets/compare_tab.dart';
import '../widgets/favourite_tab.dart';
import '../widgets/profile_tab.dart';

class DashboardPage
    extends ConsumerWidget {

  const DashboardPage({super.key});

  @override
  Widget build(
      BuildContext context,
      WidgetRef ref,
      ) {

    final index =
    ref.watch(bottomNavProvider);

    final pages = [

      const HomeTab(),
      const SearchTab(),
      const CompareTab(),
      const FavouriteTab(),
      const ProfileTab(),
    ];

    return Scaffold(

      body: pages[index],

      bottomNavigationBar:
      BottomNavigationBar(

        currentIndex: index,

        onTap: (value){

          ref.read(
              bottomNavProvider.notifier
          ).state = value;
        },

        selectedItemColor:
        Colors.blue,

        unselectedItemColor:
        Colors.grey,

        type:
        BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: 'Compare',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Favourite',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}