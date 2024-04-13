import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';

class MapScreen extends StatefulWidget {
  var data;

  MapScreen({super.key, required this.data});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(
          // aprox Brno
          49.195,
          16.6085,
        ),
        initialZoom: 13.0,
        maxZoom: 20.0,
        interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
      ),
      children: [
        openStreetMapTileLayer,
        CurrentLocationLayer(),
        MarkerLayer(markers: [
          for (var point in widget.data)
            Marker(
              width: 40.0,
              height: 40.0,
              point: LatLng(point['geometry']['coordinates'][1],
                  point['geometry']['coordinates'][0]),
              child: const Icon(
                Icons.location_on,
                size: 40.0,
                color: Colors.red,
              ),
            ),
        ])
      ],
    );
  }
}

TileLayer get openStreetMapTileLayer {
  return TileLayer(
    urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'flutter_map',
  );
}

Future<List<dynamic>> getData() async {
  // get time in milliseconds
  final int now = DateTime.now().millisecondsSinceEpoch;
  Dio dio = Dio();
  dynamic data;
  await dio
      .get(
          'https://gis.brno.cz/ags1/rest/services/Hosted/chmi/FeatureServer/0/query?time=${now - 3600000}%2C+$now&outFields=name%2C+co_8h%2C+o3_1h%2C+no2_1h%2C+so2_1h%2C+pm10_1h%2C+pm2_5_1h%2C+pm10_24h%2C+actualized&returnGeometry=true&f=geojson')
      .then((response) {
    print(response.data['features']);
    data = response.data['features'];
  }).catchError((error) {
    print(error);
    return Future(() => null);
  });
  return data;
}

class MyfutureBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          print(snapshot.data);
          return MapScreen(data: snapshot.data!);
        } else {
          return MapScreen(data: const []);
        }
      },
    );
  }
}
