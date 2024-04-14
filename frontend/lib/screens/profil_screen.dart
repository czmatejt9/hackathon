import 'package:flutter/material.dart';

class ProfilScreen extends StatefulWidget {
  final data;
  const ProfilScreen({super.key, required this.data});
  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
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
      child: const Text(
        'Profilos',
        style: TextStyle(fontSize: 24.0, color: Colors.white),
      ),
    ));
  }
}
