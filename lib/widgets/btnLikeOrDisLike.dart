import 'package:flutter/material.dart';

Expanded KBtnLikesOrComment({int? value, required Function onTap, IconData? iconData, Color? color}){
  return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => onTap(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(iconData, size: 16, color: color,),
                SizedBox(width: 4,),
                Text("$value")
              ],
            ),
          ),
        ),
      ));
}