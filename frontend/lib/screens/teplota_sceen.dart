import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class TeplotaScreen extends StatefulWidget {
  final teplota;
  const TeplotaScreen({super.key, this.teplota});
  @override
  State<TeplotaScreen> createState() => _TeplotaScreenState();
}

class _TeplotaScreenState extends State<TeplotaScreen> {
  Map<String, double> dataMap = {"Sobek": 0};
  dynamic barva_grafu = Colors.black;

  @override
  void initState() {
    super.initState();
    if (widget.teplota <= 0) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 98, 0, 243);
        dataMap = {"Mrazivo": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota <= 10 && widget.teplota > 0) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 1, 34, 255);
        dataMap = {"Studeno": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota <= 15 && widget.teplota > 10) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 1, 166, 255);
        dataMap = {"Chladno": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota <= 20 && widget.teplota > 15) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 255, 225, 1);
        dataMap = {"Na mikinku": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota <= 25 && widget.teplota > 20) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 255, 179, 1);
        dataMap = {"Pokojová teplota": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota <= 30 && widget.teplota > 25) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 255, 111, 1);
        dataMap = {"Teplo": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota > 30) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 255, 1, 1);
        dataMap = {"Horko": widget.teplota.toDouble()};
      });
    }
    if (widget.teplota > 15000000) {
      setState(() {
        barva_grafu = Color.fromARGB(255, 255, 1, 1);
        dataMap = {"Sluníčko fr 🌞": widget.teplota.toDouble()};
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
                  Color.fromARGB(255, 14, 211, 211),
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
          Padding(padding: EdgeInsets.only(top: 10)),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[
                        Color.fromARGB(255, 28, 169, 212),
                        Color.fromARGB(255, 14, 211, 211),
                      ]),
                ),
                child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      "Teplota vzduchu ovlivňuje pohodu a zdraví. Ideální rozmezí pro většinu lidí je mezi 20 až 25 stupni Celsia. Příliš vysoké teploty mohou způsobit dehydrataci a vyčerpání, zatímco příliš nízké teploty mohou vést k pocitům chladu a svalovému napětí. Udržování vhodné teploty ve vnitřních prostorách je klíčové pro komfort a pohodu.",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontSize: 15),
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
                        Color.fromARGB(0, 28, 169, 212),
                        Color.fromARGB(0, 139, 204, 242),
                      ]),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: PieChart(
                    dataMap: dataMap,
                    animationDuration: const Duration(milliseconds: 800),
                    chartLegendSpacing: 32,
                    chartRadius: MediaQuery.of(context).size.width / 3.2,
                    colorList: [barva_grafu],
                    initialAngleInDegree: 0,
                    chartType: ChartType.ring,
                    ringStrokeWidth: 32,
                    baseChartColor:
                        const Color.fromARGB(255, 0, 0, 0)!.withOpacity(0.15),
                    centerText: widget.teplota.toString() + "℃",
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
                    totalValue: 50,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
