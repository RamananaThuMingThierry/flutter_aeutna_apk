import 'dart:ui';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

TextStyle style_google = GoogleFonts.k2d(color: Colors.blueGrey);

void ErreurLogin(BuildContext context){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
}

void AutorisationAlertDialog({BuildContext? context, String? message, required Function onLoading}){
  showDialog(
      context: context!,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 65,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text(message!, textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text("Non", style: TextStyle(color: Colors.redAccent),)),
            TextButton(
                onPressed: onLoading()
                , child: Text("Oui",style: TextStyle(color: Colors.lightBlue),)),
          ],
        );
      });
}

bool verifierPrefixNumeroTelephone(String numeroTelephone){
  RegExp regex = RegExp(r'^(032|033|034|038)');
  return regex.hasMatch(numeroTelephone);
}

void MessageErreurs(BuildContext context, String? message){
  showDialog(
   context: context,
   builder: (BuildContext context) => MessageErreur(context, message)
  );
}

void MessageInformation(BuildContext context, String? message){
  showDialog(
      context: context,
      builder: (BuildContext context) => MessageInfo(context, message)
  );
}

void MessageAvertissement(BuildContext context, String? message){
  showDialog(
      context: context,
      builder: (BuildContext context) => MessageWarning(context, message)
  );
}

void MessageReussi(BuildContext context, String? message){
  showDialog(
      context: context,
      builder: (BuildContext context) => MessageSuccess(context, message)
  );
}

void ContactezNous({String? numero, String? action}) async {
  final Uri url = Uri(
      scheme: action,
      path: numero
  );
  if(await canLaunchUrl(url)){
    await launchUrl(url);
  }else{
    print("${url}");
  }
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

void ActionsCallOrMessage(BuildContext context, String? numero){
  showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(2)),
          ),
          contentPadding: EdgeInsets.all(0.0),
          insetPadding: EdgeInsets.symmetric(horizontal: 50),
          content: Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton.icon(
                    onPressed: (){
                      Navigator.pop(context);
                      ContactezNous(numero: numero, action: "tel");
                    },
                    icon: Icon(Icons.call_outlined, color: Colors.blue,),
                    label: Text("Appeler", style: style_google.copyWith(fontWeight: FontWeight.w500),)),
                Container(
                  color: Colors.grey,
                  width: .5,
                  height: 25,
                ),
                TextButton.icon(
                    onPressed: (){
                      Navigator.pop(context);
                      ContactezNous(numero: numero, action: "sms");
                    },
                    icon: Icon(Icons.sms_outlined, color: Colors.lightBlue,),
                    label: Text("Message", style: style_google.copyWith(fontWeight: FontWeight.w500),)),
              ],
            ),
          ),
        );
      });
}