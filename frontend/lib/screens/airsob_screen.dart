import 'dart:io';

import 'package:TODO/screens/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AirsobScreen extends StatefulWidget {
  final data;
  const AirsobScreen({super.key, required this.data});

  @override
  State<AirsobScreen> createState() => _AirsobScreenState();
}

class _AirsobScreenState extends State<AirsobScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Air",
                style: TextStyle(
                  color: Color.fromARGB(255, 28, 169, 212),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .moveY(
                      curve: Curves.bounceOut,
                      duration: 3000.ms,
                      end: MediaQuery.of(context).size.height,
                      begin: MediaQuery.of(context).size.width * -0.005)
                  .fadeOut(),
              const Text(
                "SOB",
                style: TextStyle(
                  color: Color.fromARGB(255, 14, 211, 211),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              )
                  .animate()
                  .moveY(
                      curve: Curves.bounceOut,
                      duration: 3000.ms,
                      end: MediaQuery.of(context).size.height,
                      begin: MediaQuery.of(context).size.width * 0.005)
                  .fadeOut()
            ],
          ),
        ],
      )),
    ).animate().fadeOut();
  }
}

Future<bool> AirSobHelper() async {
  sleep(2000.ms);
  return true;
}

class OurfutureBuilder extends StatelessWidget {
  final data;
  const OurfutureBuilder({super.key, required this.data});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AirSobHelper(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BottomBar(data: data).animate().fadeIn(duration: 2000.ms);
        } else {
          return AirsobScreen(data: data);
        }
      },
    );
  }
}
