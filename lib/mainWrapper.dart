import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Screens/dashboardScreen.dart';
import 'Screens/profileScreen.dart';
import 'Screens/portfolioScreen.dart';
import 'Screens/exploreScreen.dart';
import 'Theme/appColors.dart'; // Ensure you import your theme file

class MainWrapper extends StatefulWidget {
  final String userRole;
  final String userEmail;

  const MainWrapper({
    Key? key,
    required this.userRole,
    required this.userEmail,
  }) : super(key: key);

  @override
  _MainWrapperState createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _selectedIndex = 0;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  final Map<String, dynamic> _mockUserData = {
    'name': 'Demo User',
    'balance': 10000.0,
    'portfolioValue': 12500.0,
    'investments': [
      {'symbol': 'AAPL', 'shares': 10, 'value': 1800},
      {'symbol': 'GOOGL', 'shares': 5, 'value': 6500},
      {'symbol': 'TSLA', 'shares': 8, 'value': 1800},
    ]
  };

  // List of screens to display
  List<Widget> _screens() {
    return [
      DashboardScreen(
        userRole: widget.userRole,
        userEmail: widget.userEmail,
        dbRef: _dbRef,
        mockData: _mockUserData,
      ),
      ExploreScreen( // Moved Explore here to match the 2nd tab
        auth: _auth,
        dbRef: _dbRef,
      ),
      PortfolioScreen(
        dbRef: _dbRef,
        userId: _auth.currentUser?.uid ?? "demo",
        mockData: _mockUserData['investments'],
      ),
      ProfileScreen(
        userEmail: widget.userEmail,
        dbRef: _dbRef,
        auth: _auth,
        mockData: _mockUserData,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar removed for a cleaner, modern look
      body: _screens()[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 1),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) => setState(() => _selectedIndex = index),

          // --- THEME UPDATES ---
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: AppColors.textSecondary,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          elevation: 0,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.explore),
              label: 'Explore',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Portfolio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}