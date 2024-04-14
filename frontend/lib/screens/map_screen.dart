import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';
import 'package:TODO/air_quality_calculation.dart';
import 'package:TODO/models/data_point.dart';

class MapScreen extends StatefulWidget {
  final List<DataPoint> data;
  double zoom = 11.5;
  final MapController mapController = MapController();

  MapScreen({super.key, required this.data});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
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
              point: LatLng(
                widget.data[i].position.latitude,
                widget.data[i].position.longitude,
              ),
              child: // show icon circle with number in the middle
                  GestureDetector(
                onTap: () {
                  // show dialog with aqi value
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      var time = DateTime.fromMillisecondsSinceEpoch(
                          (widget.data[i].timestamp).toInt());
                      // select only date and time
                      String formattedTime =
                          '${time.day}.${time.month}.${time.year} ${time.hour}:${time.minute.toString().padLeft(2, '0')}';
                      if (widget.data[i].type == 'BRNO_API') {
                        return AlertDialog(
                          title: Text(
                              '${widget.data[i].name} (AQI ${widget.data[i].aqi})'),
                          content: Text('Aktualizace: $formattedTime\n'
                              'SO2: ${widget.data[i].so2_1h} µg/m³\n'
                              'CO: ${widget.data[i].co_8h} mg/m³\n'
                              'O3: ${widget.data[i].o3_1h} µg/m³\n'
                              'PM10: ${widget.data[i].pm10_24h} µg/m³\n'
                              'PM2.5: ${widget.data[i].pm2_5_1h} µg/m³\n'
                              'NO2: ${widget.data[i].no2_1h} µg/m³\n'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      }
                      return AlertDialog(
                        // TODO read the actual sensor name
                        title: Text('Sensor ${i - 8}'),
                        content: Text('Aktualizace: $formattedTime\n'
                            'Teplota: ${widget.data[i].temperature} °C\n'
                            'Vlhkost: ${widget.data[i].humidity} %\n'
                            'Tlak: ${widget.data[i].pressure} hPa\n'
                            'Rychlost větru: ${widget.data[i].windSpeed} m/s\n'
                            'Hladina zvuku: ${widget.data[i].volume} dB\n'),
                      );
                    },
                  );
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: widget.data[i].aqi != null
                          ? widget.data[i].aqi! > 50
                              ? widget.data[i].aqi! > 100
                                  ? Colors.red
                                  : Colors.yellow
                              : Colors.green
                          : Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        widget.data[i].type == 'BRNO_API'
                            ? widget.data[i].aqi.toString()
                            : widget.data[i].temperature.toString(),
                        style: TextStyle(
                          color: widget.data[i].type == 'BRNO_API'
                              ? Colors.black
                              : Colors.white,
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
