import 'package:TODO/screens/home_screen.dart';
import 'package:TODO/screens/map_screen.dart';
import 'package:TODO/screens/profil_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:TODO/models/data_point.dart';

class BottomBar extends StatefulWidget {
  final data;
  const BottomBar({super.key, required this.data});
  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int _selectedScreenIndex = 0;
  final List _screens = [
    {"screen": HomeScreen(data: []), "title": "Domovská obrazovka"},
    {"screen": MapScreen(data: []), "title": "Mapa"},
    {"screen": ProfilScreen(data: []), "title": "Podrobné informace"},
  ];

  void _selectScreen(int index) {
    setState(() {
      _selectedScreenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _screens[_selectedScreenIndex]["title"],
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 28, 169, 212),
                  Color.fromARGB(255, 14, 211, 211),
                ]),
          ),
        ),
      ),
      body: IndexedStack(
        children: <Widget>[
          HomeScreen(data: widget.data),
          MapScreen(data: widget.data),
          ProfilScreen(data: widget.data),
        ],
        index: _selectedScreenIndex,
      ),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _selectedScreenIndex,
        onTap: _selectScreen,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.green,
              ),
              label: ''),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.map,
                color: Colors.green,
              ),
              label: ""),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.green,
              ),
              label: ""),
        ],
      ),
    );
  }
}

class MyfutureBuilder extends StatelessWidget {
  MyfutureBuilder({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return BottomBar(data: snapshot.data!);
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}

Future<List<dynamic>> getData() async {
  // get time in milliseconds
  final int now = DateTime.now().millisecondsSinceEpoch;
  Dio dio = Dio();
  dynamic data;
  await dio
      .get(
          'https://gis.brno.cz/ags1/rest/services/Hosted/chmi/FeatureServer/0/query?time=${now - 2 * 3660000}%2C+$now&outFields=name%2C+co_8h%2C+o3_1h%2C+no2_1h%2C+so2_1h%2C+pm10_1h%2C+pm2_5_1h%2C+pm10_24h%2C+actualized&returnGeometry=true&f=geojson')
      .then((response) {
    data = response.data['features'];
  }).catchError((error) {
    print(error);
    return Future(() => null);
  });
  // remove duplicate names and only keep the one with biggest timestamp TODO
  List new_data = [];
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
    new_new_data[i].setAqi();
  }

  // now our sensors
  await dio.get('http://10.182.36.176:5000').then((response) {
    data = response.data['sensors'];
  }).catchError((error) {
    print(error);
    return Future(() => null);
  });
  for (int i = 0; i < data.length; i++) {
    if (i == 2) {
      new_new_data.last.volume = double.parse(data[i]['value'].substring(1));
      continue;
    }
    String? lat, lon;
    if (i == 0) {
      lat = "49.1781172";
      lon = "16.6042969";
    } else {
      lat = "49.1812072";
      lon = "16.6040314";
    }
    new_new_data.add(DataPoint.fromOurSensor(data[i], lat, lon));
    new_new_data[i + new_data.length].setAqi();
  }
  return new_new_data;
}
