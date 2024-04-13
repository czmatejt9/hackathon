import 'package:TODO/screens/teplota_sceen.dart';
import 'package:TODO/screens/vlhkost_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int teplota = 15;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(158, 255, 255, 255),
      child: ListView(
        children: [
          TextButton(
            onPressed: () {},
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Aktuální poloha",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 30,
                            ),
                          ),
                          Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 30,
                          )
                        ],
                      ),
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color.fromARGB(255, 255, 255, 255),
                                Color.fromARGB(255, 255, 255, 255),
                              ]),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.all(20)),
                          const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          const Text(
                            "Nebližší snímač  ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            teplota.toString() + "m",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.all(20)),
                          const Icon(
                            Icons.air,
                            color: Colors.black,
                            size: 25,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          const Text(
                            "Vlhkost vzduchu  ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            teplota.toString() + "℃",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(top: 10)),
                      Row(
                        children: [
                          const Padding(padding: EdgeInsets.all(20)),
                          const Icon(
                            Icons.thermostat_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          const Text(
                            "Teplota  ",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            teplota.toString() + "℃",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VlhkostScreen()),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Icon(
                        Icons.air,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text(
                        "    Kvalita ovzduší",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VlhkostScreen()),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Icon(
                        Icons.air,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text(
                        "    Vlhkost vzduchu",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const TeplotaScreen()),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Icon(
                        Icons.thermostat_outlined,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text(
                        "    Teplota",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {},
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Icon(
                        Icons.location_on_outlined,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text(
                        "    Senzory",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
