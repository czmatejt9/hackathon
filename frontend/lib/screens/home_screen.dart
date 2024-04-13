import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("nazev"),
          backgroundColor: const Color.fromRGBO(27, 146, 224, 100),
          actions: const <Widget>[]),
      body: Center()
      bottomNavigationBar: BottomNavigationBar(items: items),
    );
  }
}
