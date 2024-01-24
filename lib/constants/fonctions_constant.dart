import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';

void ErreurLogin(BuildContext context){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
}

void MessageErreurs(BuildContext context, String? message){
  showDialog(
   context: context,
   builder: (BuildContext context) => MessageErreur(context, message)
  );
}

void onLoadingLogin(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 3), () async {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil()), (route) => false);
        });
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 100),
          content: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blueGrey,),
                SizedBox(height: 16,),
                Text("Patientez...", style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
        );
      });
}

void onLoadingDeconnection(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 3), () async {
          logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
        });
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 100),
          content: Padding(
            padding: EdgeInsets.only(top: 20, bottom: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(color: Colors.blueGrey,),
                SizedBox(height: 16,),
                Text("Déconnection...", style: TextStyle(color: Colors.grey),)
              ],
            ),
          ),
        );
      });
}