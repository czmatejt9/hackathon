import 'package:dio/dio.dart';
import 'package:TODO/models/data_point.dart';
import 'package:TODO/api_keys.dart';

Future<List<DataPoint>> getData() async {
  Dio dio = Dio();
  dynamic data;
  await Future.wait([
    getBrnoData(dio),
    getOurData(dio),
    getNetAtmoData(dio),
  ]).then((value) {
    data = value[0] + value[1] + value[2];
  });

  return data;
}

Future<List<DataPoint>> getBrnoData(Dio dio) async {
  final int now = DateTime.now().millisecondsSinceEpoch;
  dynamic data;
  List new_data = [];
  await dio
      .get(
          'https://gis.brno.cz/ags1/rest/services/Hosted/chmi/FeatureServer/0/query?time=${now - 2 * 3660000}%2C+$now&outFields=name%2C+co_8h%2C+o3_1h%2C+no2_1h%2C+so2_1h%2C+pm10_1h%2C+pm2_5_1h%2C+pm10_24h%2C+actualized&returnGeometry=true&f=geojson')
      .then((response) {
    data = response.data['features'];
  }).catchError((error) {});
  if (data == null) {
    return [];
  }
  // remove duplicate names and only keep the one with biggest timestamp

  for (int i = 0; i < data.length; i++) {
    bool found = false;
    for (int j = 0; j < new_data.length; j++) {
      if (data[i]['properties']['name'] == new_data[j]['properties']['name']) {
        if (data[i]['properties']['actualized'] >
            new_data[j]['properties']['actualized']) {
          new_data[j] = data[i];
        }
        found = true;
        break;
      }
    }
    if (!found) {
      new_data.add(data[i]);
    }
  }
  List<DataPoint> new_new_data = [];
  for (int i = 0; i < new_data.length; i++) {
    new_new_data.add(DataPoint.fromBrnoApi(new_data[i]));
    new_new_data.last.setAqi();
  }
  return new_new_data;
}

Future<List<DataPoint>> getOurData(Dio dio) async {
  dynamic data;
  // TODO and OUR server
  return [];
  //return Future(() => []);
}

Future<List<DataPoint>> getNetAtmoData(Dio dio) async {
  dynamic data;
  List<DataPoint> new_data = [];
  const String url =
      "https://api.netatmo.com/api/getpublicdata?lat_ne=49.2958042&lon_ne=16.7348103&lat_sw=49.1024250&lon_sw=16.4429861&required_data=temperature&filter=true";
  await dio
      .get(url,
          options: Options(headers: {
            "Authorization": "Bearer ${NetAtmo.accessToken}",
          }))
      .then((response) {
    data = response.data;
  }).catchError((error) {});
  if (data == null) {
    return new_data;
  }
  double timestamp = (data['time_server'] * 1000).toDouble();
  data = data['body'];
  for (int i = 0; i < data.length; i++) {
    new_data.add(DataPoint.fromNetAtmo(timestamp, data[i]));
    new_data.last.setAqi();
  }
  return new_data;
}
