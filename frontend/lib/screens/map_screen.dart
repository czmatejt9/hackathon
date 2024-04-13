import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';
import 'package:TODO/air_quality_calculation.dart';

class MapScreen extends StatefulWidget {
  final data;

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
              height: 60.0,
              point: LatLng(point['geometry']['coordinates'][1],
                  point['geometry']['coordinates'][0]),
              child: // show icon with number of the aqi
                  Column(
                children: [
                  Icon(
                    Icons.location_on,
                    color: Colors.red,
                  ),
                  Text(
                    AirQuality.calculation(
                            AirQuality.parseValue(
                                point['properties']['so2_1h']),
                            AirQuality.parseValue(point['properties']['co_8h']),
                            AirQuality.parseValue(point['properties']['o3_1h']),
                            AirQuality.parseValue(
                                point['properties']['pm10_24h']),
                            AirQuality.parseValue(
                                point['properties']['pm2_5_1h']),
                            AirQuality.parseValue(
                                point['properties']['no2_1h']))
                        .toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
        ]),
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
          'https://gis.brno.cz/ags1/rest/services/Hosted/chmi/FeatureServer/0/query?time=${now - 2 * 3600000}%2C+$now&outFields=name%2C+co_8h%2C+o3_1h%2C+no2_1h%2C+so2_1h%2C+pm10_1h%2C+pm2_5_1h%2C+pm10_24h%2C+actualized&returnGeometry=true&f=geojson')
      .then((response) {
    print(response.data['features']);
    data = response.data['features'];
  }).catchError((error) {
    print(error);
    return Future(() => null);
  });
  // remove duplicate names and only keep the one with biggest timestamp
  for (int i = 0; i < data.length; i++) {
    for (int j = i + 1; j < data.length; j++) {
      if (data[i]['properties']['name'] == data[j]['properties']['name']) {
        if (data[i]['properties']['actualized'] >
            data[j]['properties']['actualized']) {
          data.removeAt(j);
        } else {
          data.removeAt(i);
        }
      }
    }
  }
  ;
  return data;
}

class MyfutureBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MapScreen(data: snapshot.data!);
        } else {
          return MapScreen(data: const []);
        }
      },
    );
  }
}
