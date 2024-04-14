import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class HlukScreen extends StatefulWidget {
  const HlukScreen({
    super.key,
  });

  @override
  State<HlukScreen> createState() => _HlukScreenState();
}

class _HlukScreenState extends State<HlukScreen> {
  int hluk = 76;
  dynamic barva_grafu = Colors.black;
  Map<String, double> dataMap = {"Sobek": 0};

  @override
  Widget build(BuildContext context) {
    if (hluk <= 50) {
      setState(() {
        dataMap = {
          "Vynikající": hluk.toDouble(),
        };
        barva_grafu = Color.fromARGB(255, 54, 0, 154);
      });
    }
    if (hluk <= 100 && hluk > 50) {
      setState(() {
        dataMap = {
          "Dobrá": hluk.toDouble(),
        };
        barva_grafu = Color.fromARGB(255, 54, 244, 228);
      });
    }
    if (hluk <= 150 && hluk > 100) {
      setState(() {
        dataMap = {
          "Střední": hluk.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 193, 244, 54);
      });
    }
    if (hluk <= 200 && hluk > 150) {
      setState(() {
        dataMap = {
          "Špatná": hluk.toDouble(),
        };
        barva_grafu = Color.fromARGB(255, 244, 174, 54);
      });
    }
    if (hluk > 200) {
      setState(() {
        dataMap = {
          "Velmi špatná": hluk.toDouble(),
        };
        barva_grafu = Color.fromARGB(255, 255, 0, 0);
      });
    }

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
            "Hlučné prostření",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          color: Color.fromARGB(118, 184, 184, 184),
          child: ListView(
            children: [
              const Padding(padding: EdgeInsets.only(top: 10)),
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
                          "Hlučné prostředí ve městě představuje závažný problém pro obyvatele. Nepřetržitý hluk z dopravy, průmyslových zón, stavebních prací a rekreačních aktivit může mít negativní dopady na zdraví a pohodu jednotlivců. Dlouhodobá expozice hluku může způsobit poruchy spánku, zvýšený stres, potíže s koncentrací a zhoršení duševního zdraví. Omezení hluku ve městě je klíčové pro zajištění kvality života obyvatelstva.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                              fontSize: 15),
                        ))),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Color.fromARGB(0, 28, 169, 212),
                            Color.fromARGB(0, 28, 169, 212),
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
                        baseChartColor: const Color.fromARGB(255, 0, 0, 0)!
                            .withOpacity(0.15),
                        centerText: hluk.toString() + "",
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
                        totalValue: 250,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
