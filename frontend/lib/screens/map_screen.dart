import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';
import 'package:TODO/air_quality_calculation.dart';

class MapScreen extends StatefulWidget {
  final data;

  const MapScreen({super.key, required this.data});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(
          // aprox Brno
          49.195,
          16.6085,
        ),
        initialZoom: 11.5,
        maxZoom: 20.0,
        minZoom: 10.0,
        interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
      ),
      children: [
        openStreetMapTileLayer,
        CurrentLocationLayer(),
        MarkerLayer(markers: [
          for (int i = 0; i < points.length; i++)
            Marker(
              width: 33.0,
              height: 33.0,
              point: LatLng(points[i].latitude, points[i].longitude),
              child: // show icon circle with number in the middle
                  GestureDetector(
                onTap: () {
                  // show dialog with aqi value
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Air Quality Index'),
                        content: Text('AQI: ${aqiValues[i]}'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: aqiValues[i] < 50
                          ? Colors.green
                          : aqiValues[i] < 100
                              ? Colors.yellow
                              : aqiValues[i] < 150
                                  ? Colors.orange
                                  : aqiValues[i] < 200
                                      ? Colors.red
                                      : Colors.purple,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        aqiValues[i].toString(),
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )),
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
