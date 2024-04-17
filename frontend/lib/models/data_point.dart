import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart';

class DataPoint {
  final LatLng position;
  final double timestamp; // unix timestamp
  final String type; // BRNO API or OUR SENSOR
  final String? name;
  double? temperature;
  double? humidity;
  double? volume; // in db
  final double? pressure;
  final double? windSpeed;
  final double? so2_1h;
  final double? co_8h;
  final double? o3_1h;
  final double? pm10_24h;
  final double? pm2_5_1h;
  final double? no2_1h;
  int? aqi;

  DataPoint(
      {required this.position,
      required this.timestamp, // unix timestamp in seconds
      required this.type,
      this.name,
      this.temperature,
      this.humidity,
      this.volume,
      this.pressure,
      this.windSpeed,
      this.so2_1h,
      this.co_8h,
      this.o3_1h,
      this.pm10_24h,
      this.pm2_5_1h,
      this.no2_1h,
      this.aqi});

  factory DataPoint.fromBrnoApi(Map<String, dynamic> json) {
    return DataPoint(
      position: LatLng(json['geometry']['coordinates'][1],
          json['geometry']['coordinates'][0]),
      timestamp: json['properties']['actualized'].toDouble(),
      type: "BRNO_API",
      name: json['properties']['name'],
      temperature: json['properties']['temperature'],
      humidity: json['properties']['humidity'],
      pressure: json['properties']['pressure'],
      windSpeed: json['properties']['wind_speed'],
      so2_1h: magicParse(json['properties']['so2_1h']),
      co_8h: magicParse(json['properties']['co_8h']) != null
          ? magicParse(json['properties']['co_8h'])! / 100
          : null,
      o3_1h: magicParse(json['properties']['o3_1h']) != null
          ? magicParse(json['properties']['o3_1h'])! / 10
          : null,
      pm10_24h: magicParse(json['properties']['pm10_24h']),
      pm2_5_1h: magicParse(json['properties']['pm2_5_1h']),
      no2_1h: magicParse(json['properties']['no2_1h']),
    );
  }

  void setAqi() {
    aqi = aqiCalculation(so2_1h ?? 0, co_8h ?? 0, o3_1h ?? 0, pm10_24h ?? 0,
        pm2_5_1h ?? 0, no2_1h ?? 0);
  }

  factory DataPoint.fromOurSensor(
      Map<String, dynamic> json, String lat, String lon) {
    // TODO change sensor id to coordinates
    // TODO add more sensor types in the future
    String type = json['type'];
    double? micValue;
    double? tempValue;
    double? humValue;
    if (type == "DHT-11") {
      List values = json['value'].split('|');
      // without first 1 charachter
      String humValue_ = values[0].substring(1);
      String tempValue_ = values[1].substring(1);
      // parse to double
      humValue = double.parse(humValue_);
      tempValue = double.parse(tempValue_);
    } else if (type == "MIC") {
      micValue = double.parse(json['value'].substring(1));
    }
    return DataPoint(
      position: LatLng(double.parse(lat), double.parse(lon)),
      timestamp: DateTime.parse(json['time']).millisecondsSinceEpoch.toDouble(),
      type: "OUR_SENSOR",
      temperature: tempValue,
      humidity: humValue,
      volume: micValue,
    );
  }

  factory DataPoint.fromNetAtmo(double timestamp, Map<String, dynamic> json) {
    Map measurements = json['measures'];
    Map<String, dynamic> measurementsValues = {};
    for (Map value in measurements.values) {
      if (!value.containsKey('res')) {
        continue;
      }
      Map vals = value['res'];
      List<dynamic> valueNum = vals.values.toList()[0];
      for (int i = 0; i < valueNum.length; i++) {
        print(value['type'][i]);
        print(valueNum[i]);
        if (valueNum[i] != null) {
          measurementsValues[value['type'][i]] = valueNum[i];
        }
      }
    }

    return DataPoint(
      position: LatLng(json['place']['location'][1].toDouble(),
          json['place']['location'][0].toDouble()),
      timestamp: timestamp,
      type: "NETATMO",
      temperature: magicParse(measurementsValues['temperature']),
      humidity: magicParse(measurementsValues['humidity']),
      pressure: magicParse(measurementsValues['pressure']),
    );
  }

  static double? magicParse(dynamic value) {
    // because some of the numbers in the API are strings for some reason?
    if (value is String) {
      return double.parse(value);
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return null;
    }
  }

  static int? aqiCalculation(
      double so2, double co, double o3, double pm10, double pm2_5, double no2) {
    // if all values are 0 or null, return null
    if (so2 == 0 && co == 0 && o3 == 0 && pm10 == 0 && pm2_5 == 0 && no2 == 0) {
      return null;
    }
    // the 2 above lines are just magic, idk the sensors are returning the values in this weird way
    const values = {
      'so2': [35, 75, 185, 304, 604],
      'co': [4.4, 9.4, 12.4, 15.4, 30.4],
      'o3': [54, 70, 85, 105, 200],
      'pm10': [54, 154, 254, 354, 424],
      'pm2_5': [12, 35.4, 55.4, 150.4, 250.4],
      'no2': [53, 100, 360, 649, 1249],
      'scale': [50, 100, 150, 200, 300],
    };

    // find the index of the scale that the value is in and calculate the percentage
    int so2Index = values['so2']!.indexWhere((element) => so2 < element);
    int coIndex = values['co']!.indexWhere((element) => co < element);
    int o3Index = values['o3']!.indexWhere((element) => o3 < element);
    int pm10Index = values['pm10']!.indexWhere((element) => pm10 < element);
    int pm2_5Index = values['pm2_5']!.indexWhere((element) => pm2_5 < element);
    int no2Index = values['no2']!.indexWhere((element) => no2 < element);

    // calculate the percentage and value from the scale as aqi index
    int so2Percentage = (so2Index > 0
            ? (so2 - values['so2']![so2Index - 1]) /
                (values['so2']![so2Index] - values['so2']![so2Index - 1]) *
                100
            : so2Index == 0
                ? (so2 / values['so2']![so2Index]) * 100
                : 101)
        .round();
    int coPercentage = (coIndex > 0
            ? (co - values['co']![coIndex - 1]) /
                (values['co']![coIndex] - values['co']![coIndex - 1]) *
                100
            : coIndex == 0
                ? (co / values['co']![coIndex]) * 100
                : 101)
        .round();
    int o3Percentage = (o3Index > 0
            ? (o3 - values['o3']![o3Index - 1]) /
                (values['o3']![o3Index] - values['o3']![o3Index - 1]) *
                100
            : o3Index == 0
                ? (o3 / values['o3']![o3Index]) * 100
                : 101)
        .round();
    int pm10Percentage = (pm10Index > 0
            ? (pm10 - values['pm10']![pm10Index - 1]) /
                (values['pm10']![pm10Index] - values['pm10']![pm10Index - 1]) *
                100
            : pm10Index == 0
                ? (pm10 / values['pm10']![pm10Index]) * 100
                : 101)
        .round();
    int pm2_5Percentage = (pm2_5Index > 0
            ? (pm2_5 - values['pm2_5']![pm2_5Index - 1]) /
                (values['pm2_5']![pm2_5Index] -
                    values['pm2_5']![pm2_5Index - 1]) *
                100
            : pm2_5Index == 0
                ? (pm2_5 / values['pm2_5']![pm2_5Index]) * 100
                : 101)
        .round();
    int no2Percentage = (no2Index > 0
            ? (no2 - values['no2']![no2Index - 1]) /
                (values['no2']![no2Index] - values['no2']![no2Index - 1]) *
                100
            : no2Index == 0
                ? (no2 / values['no2']![no2Index]) * 100
                : 101)
        .round();

    // calculate the aqi index
    int so2Aqi = so2Index != -1
        ? (so2Percentage *
                    (values['scale']![so2Index] -
                        (so2Index > 0 ? values['scale']![so2Index - 1] : 0)) /
                    100 +
                (so2Index > 0 ? values['scale']![so2Index - 1] : 0))
            .round()
        : 301;
    int coAqi = coIndex != -1
        ? (coPercentage *
                    (values['scale']![coIndex] -
                        (coIndex > 0 ? values['scale']![coIndex - 1] : 0)) /
                    100 +
                (coIndex > 0 ? values['scale']![coIndex - 1] : 0))
            .round()
        : 301;
    int o3Aqi = o3Index != -1
        ? (o3Percentage *
                    (values['scale']![o3Index] -
                        (o3Index > 0 ? values['scale']![o3Index - 1] : 0)) /
                    100 +
                (o3Index > 0 ? values['scale']![o3Index - 1] : 0))
            .round()
        : 301;

    int pm10Aqi = pm10Index != -1
        ? (pm10Percentage *
                    (values['scale']![pm10Index] -
                        (pm10Index > 0 ? values['scale']![pm10Index - 1] : 0)) /
                    100 +
                (pm10Index > 0 ? values['scale']![pm10Index - 1] : 0))
            .round()
        : 301;
    int pm2_5Aqi = pm2_5Index != -1
        ? (pm2_5Percentage *
                    (values['scale']![pm2_5Index] -
                        (pm2_5Index > 0
                            ? values['scale']![pm2_5Index - 1]
                            : 0)) /
                    100 +
                (pm2_5Index > 0 ? values['scale']![pm2_5Index - 1] : 0))
            .round()
        : 301;

    int no2Aqi = no2Index != -1
        ? (no2Percentage *
                    (values['scale']![no2Index] -
                        (no2Index > 0 ? values['scale']![no2Index - 1] : 0)) /
                    100 +
                (no2Index > 0 ? values['scale']![no2Index - 1] : 0))
            .round()
        : 301;

    // return the highest aqi index
    return [so2Aqi, coAqi, o3Aqi, pm10Aqi, pm2_5Aqi, no2Aqi].reduce((a, b) {
      return a > b ? a : b;
    });
  }
}
