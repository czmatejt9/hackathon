import 'package:TODO/screens/home_screen.dart';
import 'package:TODO/screens/map_screen.dart';
import 'package:TODO/screens/seznam_screen.dart';
import 'package:TODO/screens/teplota_sceen.dart';
import 'package:flutter/material.dart';
import 'package:TODO/helpers/get_data.dart';

class BottomBar extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;

  const BottomBar({
    super.key,
    required this.data,
  });
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": const HomeScreen(data: []), "title": "Domovská obrazovka"},
    {"screen": MapScreen(data: const []), "title": "Mapa"},
    {"screen": const SeznamScreen(data: []), "title": "Podrobné informace"},
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
        title: Text(
          _screens[_selectedScreenIndex]["title"],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 28, 169, 212),
                  Color.fromARGB(255, 14, 211, 211),
                ]),
          ),
        ),
        actions: <Widget>[
          IconButton(onPressed: () {}, icon: const Icon(Icons.cable_outlined))
        ],
      ),
      body: IndexedStack(
        index: _selectedScreenIndex,
        children: <Widget>[
          HomeScreen(data: widget.data),
          MapScreen(data: widget.data),
          SeznamScreen(data: widget.data),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.green,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.green,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.green,
              ),
              label: ""),
        ],
      ),
    );
  }
}

class MyfutureBuilder extends StatelessWidget {
  const MyfutureBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data == null) {
            // když se nenačte netatmo tak to nebude redka
            return Scaffold();
          }
          return BottomBar(
            data: snapshot.data,
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
