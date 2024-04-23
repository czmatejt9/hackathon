import 'package:TODO/helpers/location_helper.dart';
import 'package:TODO/models/data_point.dart';
import 'package:flutter/material.dart';
import 'package:TODO/screens/home_screen.dart';
import 'package:geolocator/geolocator.dart';

class SeznamScreen extends StatefulWidget {
  final List<DataPoint> data;
  final Location poloha;
  const SeznamScreen({super.key, required this.data, required this.poloha});
  @override
  State<SeznamScreen> createState() => _SeznamScreenState();
}

class _SeznamScreenState extends State<SeznamScreen> {
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

  List<String> extractStationNames(String data) {
    List<String> stationNames = [];

    RegExp regExp = RegExp(r'name: ,');
    Iterable<Match> matches = regExp.allMatches(data);

    for (Match match in matches) {
      String name = match.group(1)!;
      stationNames.add(name.splitMapJoin(","));
    }

    return stationNames;
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

    List<String> stationNames = extractStationNames(widget.data.toString());
    stationNames.forEach((name) => print(name));
    return ListView.builder(
      itemCount: widget.data.length,
      itemBuilder: (context, index) {
        return TextButton(
          onPressed: () {},
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
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data[index].name ?? (index - 8).toString(),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.location_on_outlined,
                            color: Colors.black,
                            size: 30,
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.data[index].type,
                        style: const TextStyle(color: Colors.black),
                      ),
                      Text(
                        "${Location.distance(widget.data[index].position.latitude, _currentPosition.latitude, widget.data[index].position.longitude, _currentPosition.longitude).round()}m",
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
