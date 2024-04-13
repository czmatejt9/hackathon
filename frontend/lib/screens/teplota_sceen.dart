import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TeplotaScreen extends StatefulWidget {
  const TeplotaScreen({super.key});
  @override
  State<TeplotaScreen> createState() => _TeplotaScreenState();
}

class _TeplotaScreenState extends State<TeplotaScreen> {
  int teplota = 70;
  Map<String, double> dataMap = {"ok": 40};

  @override
  void initState() {
    super.initState();
    print(teplota);
    if (teplota <= 10) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 25 && teplota > 10) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 40 && teplota > 25) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": 25,
          "25%-40% Střední": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 50 && teplota > 40) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": 25,
          "25%-40% Střední": 40,
          "40%-50% Dobrá": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 65 && teplota > 50) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": 25,
          "25%-40% Střední": 40,
          "40%-50% Dobrá": 50,
          "50%-65% Vynikající": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 75 && teplota > 65) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": 10,
          "95%-85% Špatná": 25,
          "85%-75% Střední": 40,
          "75%-65% Dobrá": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 85 && teplota > 75) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": 10,
          "95%-85% Špatná": 25,
          "85%-75% Střední": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 95 && teplota > 85) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": 10,
          "95%-85% Špatná": teplota.toDouble(),
        };
      });
    }
    if (teplota <= 100 && teplota > 95) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": teplota.toDouble(),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromARGB(255, 28, 169, 212),
                  Color.fromARGB(255, 139, 204, 242),
                ]),
          ),
        ),
        title: const Text(
          "Teplota",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Teplota vzduchu ovlivňuje pohodu a zdraví. Ideální rozmezí pro většinu lidí je mezi 20 až 25 stupni Celsia. Příliš vysoké teploty mohou způsobit dehydrataci a vyčerpání, zatímco příliš nízké teploty mohou vést k pocitům chladu a svalovému napětí. Udržování vhodné teploty ve vnitřních prostorách je klíčové pro komfort a pohodu.",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ))),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 139, 204, 242),
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    colorList: const [
                      Colors.red,
                      Colors.orange,
                      Colors.green,
                      Colors.blue,
                      Colors.purple
                    ],
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    baseChartColor:
                        const Color.fromARGB(255, 0, 0, 0)!.withOpacity(0.15),
                    centerText: teplota.toString() + "%",
                    legendOptions: const LegendOptions(
                      showLegendsInRow: false,
                      legendPosition: LegendPosition.right,
                      showLegends: true,
                      legendShape: BoxShape.circle,
                      legendTextStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    chartValuesOptions: const ChartValuesOptions(
                      showChartValueBackground: false,
                      showChartValues: false,
                      showChartValuesInPercentage: true,
                      showChartValuesOutside: true,
                      decimalPlaces: 0,
                    ),
                    totalValue: 200,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
