import 'package:flutter/material.dart';

class AjouterPublication extends StatefulWidget {
  const AjouterPublication({Key? key}) : super(key: key);

  @override
  State<AjouterPublication> createState() => _AjouterPublicationState();
}

class _AjouterPublicationState extends State<AjouterPublication> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Ajouter une publication"),
      ),
    );
  }
}
