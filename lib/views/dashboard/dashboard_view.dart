import 'package:flutter/material.dart';
import 'package:sikhsha_sathi/views/dashboard/compare_tab.dart';
import 'package:sikhsha_sathi/views/dashboard/favourite_tab.dart';
import 'package:sikhsha_sathi/views/dashboard/home_tab.dart';
import 'package:sikhsha_sathi/views/dashboard/profile_tab.dart';
import 'package:sikhsha_sathi/views/dashboard/search_tab.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [

    const HomeTab(),
    const SearchTab(),
    const CompareTab(),
    const FavouriteTab(),
    const ProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(

        currentIndex: _selectedIndex,

        onTap: (index) {

          setState(() {
            _selectedIndex = index;
          });
        },

        selectedItemColor: const Color(0xFF4D8DFF),

        unselectedItemColor: Colors.grey,

        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: "Search",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.compare_arrows),
            label: "Compare",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: "Favourites",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}