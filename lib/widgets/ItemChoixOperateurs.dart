import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class ItemOperateurs extends StatelessWidget {
  final String titre;
  final Function onPressed;
  final Color color;
  const ItemOperateurs({Key? key, required this.titre, required this.onPressed, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child:
        InkWell(
          onTap: onPressed(),
          child: Container(
              width: MediaQuery.of(context).size.width,
              height: 40,
              color: color,
              child: Center(child: Text(titre, style: style_google.copyWith(fontWeight: FontWeight.bold, color: titre == "Orange" ? Colors.black : Colors.white ),),)
          ),
        ),
    );
  }
}
