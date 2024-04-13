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
