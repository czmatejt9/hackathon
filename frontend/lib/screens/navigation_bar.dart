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
    {"screen": MyfutureBuilder(), "title": "Map Screen"},
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
          backgroundColor: const Color.fromRGBO(27, 146, 224, 100),
          actions: const <Widget>[]),
      body: _screens[_selectedScreenIndex]["screen"],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home Screen'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: "Map Screen"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), label: "Profil Screen"),
        ],
      ),
    );
  }
}
