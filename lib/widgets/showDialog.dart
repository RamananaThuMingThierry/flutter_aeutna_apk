import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';

AlertDialog MessageErreur(BuildContext context, String? message){
  return AlertDialog(
    contentPadding: EdgeInsets.all(0),
    backgroundColor: Colors.white,
    content: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(2),
          boxShadow: [
            BoxShadow(
                color: Colors.black26,
                blurRadius: 10.0,
                offset: Offset(0.0, 10.0)
            ),
          ]
      ),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(height: 100,color: Colors.red,),
              Column(
                children: [
                  Icon(Icons.warning, color: Colors.white,size: 32,),
                  SizedBox(height: 8,),
                  Text("OO0Ps...", style: TextStyle(color: Colors.white),)
                ],
              )
            ],
          ),
          SizedBox(height: 30,),
          Padding(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Text("$message", style: TextStyle(fontSize: 14, color: Colors.grey),textAlign: TextAlign.center,),
          ),
          SizedBox(height: 16,),
          Ligne(color: Colors.red),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text("O k"))
            ],
          ),
        ],
      ),

    ),
  );
}