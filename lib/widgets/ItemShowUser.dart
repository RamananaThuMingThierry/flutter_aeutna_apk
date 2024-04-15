import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class ItemShowUser extends StatelessWidget {

  /** =========================== Déclaration des variables ======================== **/
  final String titre;
  final String value;
  final IconData iconData;
  const ItemShowUser({Key? key, required this.titre, required this.value, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData, color: Colors.blueGrey,),
      title: Text(titre, style: style_google.copyWith(fontWeight: FontWeight.w500),),
      subtitle: Text(value, style: style_google.copyWith(color: Colors.black54),),
    );
  }
}
