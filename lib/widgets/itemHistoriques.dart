import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

Widget ItemListTitleHistoriques({String? text}){
  return ListTile(
    leading: Icon(Icons.send, color: Colors.grey),
    title: Text(text!, style: style_google,),
  );
}