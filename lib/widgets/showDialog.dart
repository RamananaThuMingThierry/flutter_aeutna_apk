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
              Container(height: 120,color: Colors.red,),
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
              child: Text("$message", style: TextStyle(fontSize: 14),textAlign: TextAlign.center,),
          ),
          SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: (){}, child: Text("Ok"))
            ],
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: GestureDetector(
          //     onTap: (){
          //       Navigator.pop(context);
          //     },
          //     child: Container(
          //       width: MediaQuery.of(context).size.width,
          //       decoration: BoxDecoration(
          //         color: Colors.blue,
          //         borderRadius: BorderRadius.circular(2),
          //       ),
          //       padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
          //       child: Center(
          //         child: Text("Enregistre", style: TextStyle(color: Colors.white),),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),

    ),
  );
}