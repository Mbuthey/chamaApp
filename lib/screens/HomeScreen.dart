import 'package:chama/screens/Analytics.dart';
import 'package:chama/screens/GroupsScreen.dart';
import 'package:chama/screens/SettingsScreen.dart';
import 'package:chama/screens/UserDashboard.dart';
import 'package:chama/screens/WalletScreen.dart';
import 'package:chama/utils/constants.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}




class _HomeScreenState extends State<HomeScreen> {
  int _selectedPageIndex = 0;
  final PageController _pageController = PageController();

  void _onPageSelected(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Constants.colorPrimary,
        body: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() {
              _selectedPageIndex = index;
            });
          },
          children: const <Widget>[
            UserDashboard(),
            GroupsScreen(),
            WalletScreen(),
            Analytics(),
          ],
        ),
        bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _selectedPageIndex,
          onItemTapped: _onPageSelected,
        ),
      ),
    );
  }
}

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onItemTapped;

  const CustomBottomNavigationBar({super.key, 
    required this.currentIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5DC), // Light beige color
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildNavItem(Icons.home_outlined, 0),
          _buildNavItem(Icons.groups_outlined, 1),
          _buildNavItem(Icons.account_balance_wallet_outlined, 2),
          _buildNavItem(Icons.bar_chart_outlined, 3),
          _buildPopupMenuItem(context, Icons.more_vert_outlined),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, int index) {
    bool isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        decoration: isSelected
            ? BoxDecoration(
                color: Constants.bgDarkGreen,
                borderRadius: BorderRadius.circular(20),
              )
            : null,
        padding: const EdgeInsets.all(10),
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Constants.bgDarkGreen,
          size: 30,
        ),
      ),
    );
  }

  Widget _buildPopupMenuItem(BuildContext context, IconData icon) {
    return PopupMenuButton<String>(
      icon: Icon(icon, color: Colors.green[900], size: 30),
      onSelected: (String result) {
        if (result == 'settings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'settings',
          child: Text('Settings'),
        ),
        // Add more menu items here if needed
      ],
    );
  }
}
