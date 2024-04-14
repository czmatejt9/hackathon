import 'package:TODO/air_quality_calculation.dart';
import 'package:TODO/screens/hlucny_screen.dart';
import 'package:TODO/screens/kvalita_screen.dart';
import 'package:TODO/screens/teplota_sceen.dart';
import 'package:TODO/screens/vlhkost_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math' as math;
import 'package:TODO/models/data_point.dart';
import 'package:latlong2/latlong.dart';

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  static double distance(double lat1, double lat2, double lon1, double lon2) {
    const R = 6371e3; // metres
    double phi1 = lat1 * math.pi / 180; // φ, λ in radians
    double phi2 = lat2 * math.pi / 180;
    double deltaPhi = (lat2 - lat1) * math.pi / 180;
    double deltaLambda = (lon2 - lon1) * math.pi / 180;

    double a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c; // in metres
  }
}

class HomeScreen extends StatefulWidget {
  final List<DataPoint> data;
  const HomeScreen({super.key, required this.data});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int teplota = 15;
  int vlhkost = 53;
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

  // Zadaná geolokace

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

  List<Location> extractLocations(List<DataPoint> data) {
    List<Location> locations = [];

    for (DataPoint point in data) {
      locations
          .add(Location(point.position.latitude, point.position.longitude));
    }

    return locations;
  }

  List aqiValues = [];

  @override
  Widget build(BuildContext context) {
    for (var point in widget.data) {
      if (point.aqi != null) {
        aqiValues.add(point.aqi);
      }
    }
    Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.best,
            forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });
    }).catchError((e) {
      print(e);
    });
    Location targetLocation =
        Location(_currentPosition.latitude, _currentPosition.longitude);

    Location nearestLocation =
        findNearestLocation(targetLocation, extractLocations(widget.data));
    int values = 0;
    int c = 0;
    for (DataPoint point in widget.data) {
      if (point.aqi != null) {
        values += point.aqi!;
        c += 1;
      }
    }
    double values_vlhkost = widget.data.last.humidity!;
    double values_teplota = widget.data.last.temperature!;

    return Container(
      color: const Color.fromARGB(118, 184, 184, 184),
      child: Column(
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
                            Location.distance(
                                        nearestLocation.latitude,
                                        _currentPosition.latitude,
                                        nearestLocation.longitude,
                                        _currentPosition.longitude)
                                    .round()
                                    .toString() +
                                "m",
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
                            (values / c).round().toString(),
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
                            values_vlhkost.round().toString() + "%",
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
                            values_teplota.round().toString() + "℃",
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
                          airquality: (values / c).round(),
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
                    builder: (context) =>
                        VlhkostScreen(vlhkost: values_vlhkost.round())),
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
                          teplota: values_teplota.round(),
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
                MaterialPageRoute(builder: (context) => const HlukScreen()),
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
                        Icons.mic_none_outlined,
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
