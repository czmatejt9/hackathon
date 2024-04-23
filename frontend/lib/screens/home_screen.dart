import 'package:TODO/screens/hlucny_screen.dart';
import 'package:TODO/screens/kvalita_screen.dart';
import 'package:TODO/screens/teplota_sceen.dart';
import 'package:TODO/screens/vlhkost_screen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:TODO/models/data_point.dart';
import 'package:TODO/helpers/location_helper.dart';

class HomeScreen extends StatefulWidget {
  final List<DataPoint> data;
  const HomeScreen({super.key, required this.data});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Position _currentPosition = Position(
      accuracy: 0,
      longitude: 0,
      latitude: 0,
      timestamp: DateTime(2024),
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0);

  Location findNearestLocation(
      Location targetLocation, List<Location> locations) {
    Location nearestLocation = Location(49.6834, 16.3556);
    double minDistance = double.infinity;

    for (Location location in locations) {
      double distance = Location.distance(targetLocation.latitude,
          location.latitude, targetLocation.longitude, location.longitude);
      if (distance < minDistance) {
        minDistance = distance;
        setState(() {
          nearestLocation = location;
        });
      }
    }

    return nearestLocation;
  }

  @override
  Widget build(BuildContext context) {
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {});

    Location nearestLocation = findNearestLocation(
        Location(_currentPosition.latitude, _currentPosition.longitude),
        extractLocations(widget.data));

    DataPoint nearestDataPoint =
        findDataPointwithLocation(nearestLocation, widget.data);

    return Container(
      color: const Color.fromARGB(118, 184, 184, 184),
      child: ListView(
        children: [
          const Padding(padding: EdgeInsets.only(top: 10)),
          TextButton(
            onPressed: () {},
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 14, 211, 211),
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
                              color: Colors.black,
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
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${Location.distance(nearestLocation.latitude, _currentPosition.latitude, nearestLocation.longitude, _currentPosition.longitude).round()}m",
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
                            Icons.forest_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          const Text(
                            "Kvalita ovzduší  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            nearestDataPoint.aqi.toString(),
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
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${nearestDataPoint.humidity ?? "N/A".toString()}%",
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
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${nearestDataPoint.temperature ?? "N/A".toString()}℃",
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
                            Icons.volume_down_outlined,
                            color: Colors.black,
                            size: 25,
                          ),
                          const Padding(padding: EdgeInsets.all(10)),
                          const Text(
                            "Hlučnost  ",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            "${nearestDataPoint.volume ?? "N/A".toString()}db",
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
                MaterialPageRoute(
                    builder: (context) => KvalitaScreen(
                          airquality: 25,
                        )),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 28, 169, 212),
                      ]),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Icon(
                        Icons.forest_outlined,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text(
                        "    Kvalita ovzduší",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VlhkostScreen(vlhkost: 15)),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 28, 169, 212),
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
                            color: Colors.black),
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TeplotaScreen(
                          teplota: 25,
                        )),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 28, 169, 212),
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
                            color: Colors.black),
                      )
                    ],
                  ),
                )),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HlukScreen(
                          data: widget.data,
                          nearestdataPointVolume: nearestDataPoint.volume,
                        )),
              );
            },
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 28, 169, 212),
                      ]),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(padding: EdgeInsets.only(left: 30)),
                      Icon(
                        Icons.volume_down_outlined,
                        size: 40,
                        color: Colors.black,
                      ),
                      Text(
                        "    Hlučnost",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
