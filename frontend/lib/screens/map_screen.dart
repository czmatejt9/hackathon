import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:dio/dio.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

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
        interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate),
      ),
      children: [
        openStreetMapTileLayer,
        CurrentLocationLayer(),
        MarkerLayer(markers: [
          Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(49.195, 16.6085),
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

List<Map<String, Map>> getData() {
  List<Map<String, Map>> data = [];
  Dio dio = Dio();
  dio
      .get(
          'https://gis.brno.cz/ags1/rest/services/Hosted/chmi/FeatureServer/0/query?time=1706927960000%2C+1706942360000&geometry=%7Bxmin%3A+16.551400%2C+ymin%3A+49.217700%2C+xmax%3A+16.666800%2C+ymax%3A+49.146500%7D&outFields=name%2C+co_8h%2C+o3_1h%2C+no2_1h%2C+so2_1h%2C+pm10_1h%2C+pm2_5_1h%2C+pm10_24h&returnGeometry=true&f=geojson')
      .then((response) {
    data = response.data;
  });
  return data;
}
