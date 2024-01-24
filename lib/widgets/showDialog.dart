import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';

AlertDialog MessageErreur(BuildContext context, String? message){
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
    ),
    contentPadding: EdgeInsets.all(0),
    elevation: 0,
    backgroundColor: Colors.transparent,
    content: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(16),
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
              Container(height: 100,decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)
                  ),
              ),),
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