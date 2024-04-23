import 'dart:math' as math;

import 'package:TODO/models/data_point.dart';
import 'package:latlong2/latlong.dart';

class Location {
  final double latitude;
  final double longitude;

  Location(this.latitude, this.longitude);

  static double distance(double lat1, double lat2, double lon1, double lon2) {
    const R = 6371e3; // metres
    double phi1 = lat1 * math.pi / 180; // φ, λ in radians
    double phi2 = lat2 * math.pi / 180;
    double deltaPhi = (lat2 - lat1) * math.pi / 180;
    double deltaLambda = (lon2 - lon1) * math.pi / 180;

    double a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);

    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return R * c; // in metres
  }
}

DataPoint findDataPointwithLocation(Location poloha, List<DataPoint> data) {
  for (DataPoint value in data) {
    if (value.position.latitude == poloha.latitude &&
        value.position.longitude == poloha.longitude) {
      return value;
    }
  }
  // sorry smurfe nevim jak to líp napsat fixnito pls dík
  return DataPoint(
      position: LatLng(poloha.latitude, poloha.longitude),
      timestamp: DateTime.now().millisecondsSinceEpoch.toDouble(),
      type: "Error");
}

List<Location> extractLocations(List<DataPoint> data) {
  List<Location> locations = [];

  for (DataPoint point in data) {
    locations.add(Location(point.position.latitude, point.position.longitude));
  }

  return locations;
}
