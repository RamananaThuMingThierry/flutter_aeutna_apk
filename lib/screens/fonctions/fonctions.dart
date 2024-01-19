import 'package:flutter/material.dart';

class FonctionsScreen extends StatefulWidget {
  const FonctionsScreen({Key? key}) : super(key: key);

  @override
  State<FonctionsScreen> createState() => _FonctionState();
}

class _FonctionState extends State<FonctionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Fonctions"),
      ),
    );
  }
}
