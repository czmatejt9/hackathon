import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class KvalitaScreen extends StatefulWidget {
  final airquality;
  const KvalitaScreen({super.key, this.airquality});

  @override
  State<KvalitaScreen> createState() => _KvalitaScreenState();
}

class _KvalitaScreenState extends State<KvalitaScreen> {
  dynamic barva_grafu = Colors.black;
  Map<String, double> dataMap = {"Sobek": 0};

  @override
  Widget build(BuildContext context) {
    if (widget.airquality <= 50) {
      setState(() {
        dataMap = {
          "Vynikající": widget.airquality.toDouble(),
        };
        barva_grafu = Color.fromARGB(255, 54, 0, 154);
      });
    }
    if (widget.airquality <= 100 && widget.airquality > 50) {
      setState(() {
        dataMap = {
          "Dobrá": widget.airquality.toDouble(),
        };
        barva_grafu = Color.fromARGB(255, 54, 244, 228);
      });
    }
    if (widget.airquality <= 150 && widget.airquality > 100) {
      setState(() {
        dataMap = {
          "Střední": widget.airquality.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 193, 244, 54);
      });
    }
    if (widget.airquality <= 200 && widget.airquality > 150) {
      setState(() {
        dataMap = {
          "Špatná": widget.airquality.toDouble(),
        };
        barva_grafu = const Color.fromARGB(255, 244, 174, 54);
      });
    }
    if (widget.airquality > 200) {
      setState(() {
        dataMap = {
          "Velmi špatná": widget.airquality.toDouble(),
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
            "Kvalita vzduchu",
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
                          "Kvalita vzduchu je klíčovým indikátorem životního prostředí a lidského zdraví. Ovlivňují ji různé škodlivé látky, jako jsou: \n\nSO2 (oxid siřičitý): Pochází zejména z průmyslových procesů a spalování fosilních paliv obsahujících síru, jako je uhlí a ropa. Může způsobovat dýchací problémy a nepohodlí. \n\nCO (oxid uhelnatý): Vzniká při nedokonalém spalování organických látek, jako jsou uhlí, dřevo nebo benzín. Jeho inhalace může vést k závratím, bolesti hlavy a v extrémních případech i k smrti.\n\nO3 (ozón): Přítomnost ozónu ve spodních vrstvách atmosféry může způsobovat dráždění dýchacích cest a zhoršovat astma.\n\nPM10 a PM2.5 (částice): Drobné částice prachu, sazí a dalších látek ve vzduchu, které mohou proniknout do plic a způsobovat dýchací potíže a zdravotní problémy.\n\nNO2 (oxid dusičitý): Vzniká především při spalování fosilních paliv. Vyšší koncentrace oxidu dusičitého ve vzduchu mohou zhoršovat astma a dráždit dýchací cesty.",
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
                        centerText: widget.airquality.toString() + "",
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
              Padding(padding: EdgeInsets.all(40)),
            ],
          ),
        ));
  }
}
