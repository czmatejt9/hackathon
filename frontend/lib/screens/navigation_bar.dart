import 'dart:ui';

import 'package:TODO/screens/home_screen.dart';
import 'package:TODO/screens/map_screen.dart';
import 'package:TODO/screens/profil_screen.dart';
import 'package:flutter/material.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({super.key});
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": HomeScreen(), "title": "Home Screen"},
    {"screen": MapScreen(), "title": "Map Screen"},
    {"screen": ProfilScreen(), "title": "Profil Screen"},
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedScreenIndex]["title"]),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 28, 169, 212),
                  Color.fromARGB(255, 139, 204, 242),
                ]),
          ),
        ),
      ),
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Screen'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map Screen"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profil Screen"),
        ],
      ),
    );
  }
}
