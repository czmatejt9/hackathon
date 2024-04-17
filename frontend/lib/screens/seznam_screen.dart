import 'package:TODO/models/data_point.dart';
import 'package:flutter/material.dart';
import 'package:TODO/screens/home_screen.dart';

class SeznamScreen extends StatefulWidget {
  final List<DataPoint> data;
  const SeznamScreen({super.key, required this.data});
  @override
  State<SeznamScreen> createState() => _SeznamScreenState();
}

class _SeznamScreenState extends State<SeznamScreen> {
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
    List<String> stationNames = extractStationNames(widget.data.toString());
    stationNames.forEach((name) => print(name));
    return Center(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: ListView.builder(
        itemCount: widget.data.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(widget.data[index].name ?? (index - 8).toString()),
              subtitle: Text(
                  'Coordinates: ${widget.data[index].position.latitude}, ${widget.data[index].position.longitude}'),
            ),
          );
        },
      ),
    ));
  }
}
