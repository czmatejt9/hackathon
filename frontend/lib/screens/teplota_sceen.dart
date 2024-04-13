import 'package:flutter/material.dart';

class TeplotaScreen extends StatefulWidget {
  const TeplotaScreen({super.key});
  @override
  State<TeplotaScreen> createState() => _TeplotaScreenState();
}

class _TeplotaScreenState extends State<TeplotaScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Vlhkost vzduchu"),
      ),
      body: ListView(
        children: [
          Text(
              "Vlhkost vzduchu je míra vodních par ve vzduchu. Vysoká vlhkost může udržovat hydrataci kůže a sliznic, ale také podporuje růst plísní a roztočů, což může být škodlivé pro zdraví. Naopak nízká vlhkost snižuje riziko plísní, ale může způsobit podráždění dýchacích cest a kůže, a také statickou elektřinu. Optimalizace vlhkosti vzduchu je klíčová pro zajištění pohodlí a zdraví člověka."),
        ],
      ),
    );
  }
}
