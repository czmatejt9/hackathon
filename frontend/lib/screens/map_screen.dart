import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';
import 'package:TODO/air_quality_calculation.dart';

class MapScreen extends StatefulWidget {
  final data;
  double zoom = 11.5;
  final MapController mapController = MapController();

  MapScreen({super.key, required this.data});

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
      mapController: widget.mapController,
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
          for (int i = 0; i < widget.data.length; i++)
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
                      print(widget.data[i]['properties']['actualized']);
                      var time = DateTime.fromMillisecondsSinceEpoch(
                          widget.data[i]['properties']['actualized']);
                      // select only date and time
                      String formattedTime =
                          '${time.day}.${time.month}.${time.year} ${time.hour}:${time.minute}';

                      return AlertDialog(
                        title: Text(widget.data[i]['properties']['name'] +
                            ' (AQI ${aqiValues[i]})'),
                        content: Text('Aktualizace: $formattedTime\n'
                            'SO2: ${widget.data[i]['properties']['so2_1h'] ?? 'Nedostupné'}\n'
                            'CO: ${widget.data[i]['properties']['co_8h'] ?? 'Nedostupné'}\n'
                            'O3: ${widget.data[i]['properties']['o3_1h'] ?? 'Nedostupné'}\n'
                            'PM10: ${widget.data[i]['properties']['pm10_24h'] ?? 'Nedostupné'}\n'
                            'PM2.5: ${widget.data[i]['properties']['pm2_5_1h'] ?? 'Nedostupné'}\n'
                            'NO2: ${widget.data[i]['properties']['no2_1h'] ?? 'Nedostupné'}\n'),
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
        // please add zoom buttons in the top right corner not using zoom buttons plugin
        // I said right cornet not left bro

        Positioned(
          top: 10.0,
          left: MediaQuery.of(context).size.width - 70.0,
          child: Column(
            children: [
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    widget.zoom += 0.5;
                    if (widget.zoom > 20.0) {
                      widget.zoom = 20.0;
                    }
                    widget.mapController.move(
                      widget.mapController.center,
                      widget.zoom,
                    );
                  });
                },
                child: const Icon(Icons.add),
              ),
              FloatingActionButton(
                onPressed: () {
                  setState(() {
                    widget.zoom -= 0.5;
                    if (widget.zoom < 10.0) {
                      widget.zoom = 10.0;
                    }
                    widget.mapController.move(
                      widget.mapController.center,
                      widget.zoom,
                    );
                  });
                },
                child: const Icon(Icons.remove),
              ),
            ],
          ),
        ),
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
