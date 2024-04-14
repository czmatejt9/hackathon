import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class VlhkostScreen extends StatefulWidget {
  final vlhkost;
  const VlhkostScreen({super.key, this.vlhkost});
  @override
  State<VlhkostScreen> createState() => _VlhkostScreenState();
}

class _VlhkostScreenState extends State<VlhkostScreen> {
  dynamic barva_grafu = Colors.black;
  Map<String, double> dataMap = {"Sobek": 0};

  @override
  void initState() {
    super.initState();
    print(widget.vlhkost);
    if (widget.vlhkost <= 10) {
      setState(() {
        dataMap = {
          "Velmi špatná": widget.vlhkost.toDouble(),
        };
        barva_grafu = Colors.red;
      });
    }
    if (widget.vlhkost <= 25 && widget.vlhkost > 10) {
      setState(() {
        dataMap = {
          "Špatná": widget.vlhkost.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 244, 174, 54);
      });
    }
    if (widget.vlhkost <= 40 && widget.vlhkost > 25) {
      setState(() {
        dataMap = {
          "Střední": widget.vlhkost.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 193, 244, 54);
      });
    }
    if (widget.vlhkost <= 50 && widget.vlhkost > 40) {
      setState(() {
        dataMap = {
          "Dobrá": widget.vlhkost.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 57, 244, 54);
      });
    }
    if (widget.vlhkost <= 65 && widget.vlhkost > 50) {
      setState(() {
        dataMap = {
          "Vynikající": widget.vlhkost.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 54, 244, 216);
      });
    }
    if (widget.vlhkost <= 75 && widget.vlhkost > 65) {
      setState(() {
        dataMap = {
          "Dobrá": (100 - widget.vlhkost).toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 57, 244, 54);
      });
    }
    if (widget.vlhkost <= 85 && widget.vlhkost > 75) {
      setState(() {
        dataMap = {
          "Střední": (100 - widget.vlhkost).toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 193, 244, 54);
      });
    }
    if (widget.vlhkost <= 95 && widget.vlhkost > 85) {
      setState(() {
        dataMap = {
          "Špatná": (100 - widget.vlhkost).toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 244, 174, 54);
      });
    }
    if (widget.vlhkost <= 100 && widget.vlhkost > 95) {
      setState(() {
        dataMap = {
          "Velmi špatná": (100 - widget.vlhkost).toDouble(),
        };
        barva_grafu = Colors.red;
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
                        centerText: widget.vlhkost.toString() + "%",
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
                        totalValue: 65,
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
