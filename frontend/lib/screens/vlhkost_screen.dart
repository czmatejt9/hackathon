import 'package:flutter/material.dart';

class VlhkostScreen extends StatefulWidget {
  const VlhkostScreen({super.key});
  @override
  State<VlhkostScreen> createState() => _VlhkostScreenState();
}

class _VlhkostScreenState extends State<VlhkostScreen> {
  List<String> seznam = [
    'Prvek 1',
    'Prvek 2',
    'Prvek 3',
    'Prvek 4',
    'Prvek 5',
    'Prvek 6',
    'Prvek 7',
    'Prvek 8',
    'Prvek 9',
    'Prvek 10',
    'Prvek 1',
    'Prvek 2',
    'Prvek 3',
    'Prvek 4',
    'Prvek 5',
    'Prvek 6',
    'Prvek 7',
    'Prvek 8',
    'Prvek 9',
    'Prvek 10',
  ];

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
          "Vlhkost vzduchu",
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
                      "Vlhkost vzduchu je míra vodních par ve vzduchu. Vysoká vlhkost může udržovat hydrataci kůže a sliznic, ale také podporuje růst plísní a roztočů, což může být škodlivé pro zdraví. Naopak nízká vlhkost snižuje riziko plísní, ale může způsobit podráždění dýchacích cest a kůže, a také statickou elektřinu. Optimalizace vlhkosti vzduchu je klíčová pro zajištění pohodlí a zdraví člověka.",
                      style: TextStyle(
                          fontWeight: FontWeight.w600, color: Colors.white),
                    ))),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.6,
            child: ListView.builder(
              itemCount: seznam.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                    'Prvek číslo ${seznam[index]}',
                    style: TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
