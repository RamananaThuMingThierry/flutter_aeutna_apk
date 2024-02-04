import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class WidgetListTitle extends StatelessWidget {
  final String title;
  final IconData leading;
  final IconData trailing;
  final Function onTap;

  WidgetListTitle({Key? key, required this.title,required this.leading,required this.trailing,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return  Card(
      margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      elevation: 0,
      shape: Border(),
      child: ListTile(
        onTap: onTap(),
        leading: Icon(leading, color: Colors.grey,),
        title: Text("${title}", style: style_google,),
        trailing: Icon(trailing, color: Colors.blueGrey,),
      ),
    );;
  }
}
