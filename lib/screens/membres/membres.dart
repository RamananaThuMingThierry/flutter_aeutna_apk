import 'package:flutter/material.dart';

class Membres extends StatefulWidget {
  const Membres({Key? key}) : super(key: key);

  @override
  State<Membres> createState() => _MembresState();
}

class _MembresState extends State<Membres> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Membres AEUTAN"),
      ),
    );
  }
}
