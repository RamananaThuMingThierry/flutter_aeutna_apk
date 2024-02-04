import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  Button({required this.onPressed, required this.name, required this.color});

  // Déclarations des variables
  final Function onPressed;
  final String name;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: color,
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Text(name, style: style_google.copyWith(color: Colors.white),),
      onPressed: onPressed(),
    );
  }
}
