import 'package:flutter/material.dart';

class ItemOperateurs extends StatelessWidget {
  final String titre;
  final Function onPressed;
  final Color color;
  const ItemOperateurs({Key? key, required this.titre, required this.onPressed, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: MaterialButton(
            onPressed: onPressed(),
            child: Text(titre, style: TextStyle(fontWeight: FontWeight.bold, color: titre == "Orange" ? Colors.black : Colors.white ),),
            color: color,
          ),
        ),
      ],
    );
  }
}
