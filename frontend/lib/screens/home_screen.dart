import 'package:TODO/air_quality_calculation.dart';
import 'package:TODO/screens/kvalita_screen.dart';
import 'package:TODO/screens/teplota_sceen.dart';
import 'package:TODO/screens/vlhkost_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

import 'package:latlong2/latlong.dart';

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  double distanceTo(Location other) {
    const double earthRadius = 6371; // Radius of the earth in km
    double lat1Rad = _degreesToRadians(latitude);
    double lat2Rad = _degreesToRadians(other.latitude);
    double latDiff = _degreesToRadians(other.latitude - latitude);
    double lonDiff = _degreesToRadians(other.longitude - longitude);

    double a = sin(latDiff / 2) * sin(latDiff / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(lonDiff / 2) * sin(lonDiff / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    double distance = earthRadius * c; // Distance in km

    return distance;
  }

  double _degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }
}

class HomeScreen extends StatefulWidget {
  final data;
  const HomeScreen({super.key, required this.data});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int teplota = 15;
  late Position _currentPosition;

  double degreesToRadians(double degrees) {
    return degrees * pi / 180;
  }

  double distanceInKmBetweenEarthCoordinates(
      double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371;

    double dLat = degreesToRadians(lat2 - lat1);
    double dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadiusKm * c;
  }

  // Zadaná geolokace

  Location findNearestLocation(
      Location targetLocation, List<Location> locations) {
    late Location nearestLocation;
    double minDistance = double.infinity;

    for (Location location in locations) {
      double distance = distanceInKmBetweenEarthCoordinates(
          targetLocation.latitude,
          targetLocation.longitude,
          location.latitude,
          location.longitude);
      print(distance.toString());
      if (distance < minDistance) {
        minDistance = distance;
        nearestLocation = location;
      }
    }

    return nearestLocation;
  }

  List<Location> extractLocations(String data) {
    List<Location> locations = [];

    RegExp regex = RegExp(r'\[(-?\d+\.\d+), (-?\d+\.\d+)\]');
    Iterable<Match> matches = regex.allMatches(data);

    for (Match match in matches) {
      double latitude = double.parse(match.group(1) ?? "Sobek");
      double longitude = double.parse(match.group(2) ?? "Sobíno");
      locations.add(Location(latitude, longitude));
    }

    return locations;
  }

  List points = [];
  List aqiValues = [];

  @override
  Widget build(BuildContext context) {
    for (var point in widget.data) {
      points.add(LatLng(point['geometry']['coordinates'][1],
          point['geometry']['coordinates'][0]));
      aqiValues.add(AirQuality.calculation(
          AirQuality.parseValue(point['properties']['so2_1h']),
          AirQuality.parseValue(point['properties']['co_8h']),
          AirQuality.parseValue(point['properties']['o3_1h']),
          AirQuality.parseValue(point['properties']['pm10_24h']),
          AirQuality.parseValue(point['properties']['pm2_5_1h']),
          AirQuality.parseValue(point['properties']['no2_1h'])));
    }
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
                            aqiValues[0].toString(),
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
                              color: Colors.black,
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
                MaterialPageRoute(
                    builder: (context) => KvalitaScreen(
                          airquality: aqiValues[0],
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
                MaterialPageRoute(builder: (context) => const VlhkostScreen()),
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
                MaterialPageRoute(builder: (context) => const TeplotaScreen()),
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
              Location targetLocation = Location(
                  _currentPosition.latitude, _currentPosition.longitude);

              Location nearestLocation = findNearestLocation(
                  targetLocation, extractLocations(widget.data.toString()));
              print(
                  'Nejbližší lokace k zadané geolokaci: ${nearestLocation.latitude}, ${nearestLocation.longitude}');
              print(_currentPosition);
              print(nearestLocation.distanceTo(Location(
                  _currentPosition.latitude, _currentPosition.longitude)));
              print(distanceInKmBetweenEarthCoordinates(
                  nearestLocation.latitude,
                  nearestLocation.longitude,
                  _currentPosition.latitude,
                  _currentPosition.longitude));
              print(extractLocations(widget.data.toString()));
              print(widget.data.toString());
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
