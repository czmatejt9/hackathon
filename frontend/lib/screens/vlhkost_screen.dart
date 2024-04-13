import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class VlhkostScreen extends StatefulWidget {
  const VlhkostScreen({super.key});
  @override
  State<VlhkostScreen> createState() => _VlhkostScreenState();
}

class _VlhkostScreenState extends State<VlhkostScreen> {
  int vlhkost_vzduchu = 70;
  Map<String, double> dataMap = {"ok": 40};

  @override
  void initState() {
    super.initState();
    print(vlhkost_vzduchu);
    if (vlhkost_vzduchu <= 10) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 25 && vlhkost_vzduchu > 10) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 40 && vlhkost_vzduchu > 25) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": 25,
          "25%-40% Střední": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 50 && vlhkost_vzduchu > 40) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": 25,
          "25%-40% Střední": 40,
          "40%-50% Dobrá": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 65 && vlhkost_vzduchu > 50) {
      setState(() {
        dataMap = {
          " 0%-10% Velmi špatná": 10,
          "10%-25% Špatná": 25,
          "25%-40% Střední": 40,
          "40%-50% Dobrá": 50,
          "50%-65% Vynikající": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 75 && vlhkost_vzduchu > 65) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": 10,
          "95%-85% Špatná": 25,
          "85%-75% Střední": 40,
          "75%-65% Dobrá": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 85 && vlhkost_vzduchu > 75) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": 10,
          "95%-85% Špatná": 25,
          "85%-75% Střední": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 95 && vlhkost_vzduchu > 85) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": 10,
          "95%-85% Špatná": vlhkost_vzduchu.toDouble(),
        };
      });
    }
    if (vlhkost_vzduchu <= 100 && vlhkost_vzduchu > 95) {
      setState(() {
        dataMap = {
          "100%-95% Velmi špatná": vlhkost_vzduchu.toDouble(),
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
                    Color.fromARGB(255, 14, 211, 211),
                  ]),
            ),
          ),
          title: const Text(
            "Vlhkost vzduchu",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          color: Color.fromARGB(118, 184, 184, 184),
          child: Column(
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
                          "Vlhkost vzduchu je míra vodních par ve vzduchu. Vysoká vlhkost může udržovat hydrataci kůže a sliznic, ale také podporuje růst plísní a roztočů, což může být škodlivé pro zdraví. Naopak nízká vlhkost snižuje riziko plísní, ale může způsobit podráždění dýchacích cest a kůže, a také statickou elektřinu. Optimalizace vlhkosti vzduchu je klíčová pro zajištění pohodlí a zdraví člověka.",
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
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
                            Color.fromARGB(255, 28, 169, 212),
                            Color.fromARGB(255, 28, 169, 212),
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
                        baseChartColor: const Color.fromARGB(255, 0, 0, 0)!
                            .withOpacity(0.15),
                        centerText: vlhkost_vzduchu.toString() + "%",
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
        ));
  }
}
