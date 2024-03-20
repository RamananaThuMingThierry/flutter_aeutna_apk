import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class ItemDrawer extends StatelessWidget {
  final String titre;
  final Function onTap;
  final IconData iconData;
  ItemDrawer({Key? key, required this.titre, required this.onTap, required this.iconData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(iconData, color: Colors.blueGrey,),
      title: Text(titre, style: style_google,),
      onTap: onTap(),
    );
  }
}
