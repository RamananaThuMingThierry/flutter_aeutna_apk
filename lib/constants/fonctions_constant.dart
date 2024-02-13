import 'dart:ui';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/admin/administrateurs.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/enattente.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;

TextStyle style_google = GoogleFonts.k2d(color: Colors.blueGrey);
Text TitreText(String titre){
  return Text(titre, style: style_google.copyWith(fontWeight: FontWeight.bold),);
}

void ErreurLogin(BuildContext context){
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
}

void deconnectionAlertDialog(BuildContext context){
  showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext buildContext){
        return AlertDialog(
          backgroundColor: Colors.white,
          content: SizedBox(
            height: 70,
            child: Column(
              children: [
                SizedBox(height: 20,),
                Text("Vous déconnecter de votre compte?", textAlign: TextAlign.center, style: style_google.copyWith(fontSize: 18),),
              ],
            ),
          ),
          contentPadding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
          actions: [
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  print("Annuler");
                },
                child: Text("Annuler", style: style_google.copyWith(color: Colors.lightBlue),)),
            TextButton(
                onPressed: (){
                  Navigator.pop(context);
                  onLoadingDeconnection(context);
                }, child: Text("Se déconnecter",style: style_google.copyWith(color: Colors.redAccent))),
          ],
        );
      });
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

String separerParEspace(String texte){
  return texte.replaceAllMapped(RegExp(r".{3}"), (match) => "${match.group(0)} ");
}

void redirectToFacebook({String? nom}) async {
  String url = 'https://www.facebook.com/$nom';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Impossible de lancer $url';
  }
}

String ajouterTroisPointSiTextTropLong({String? texte, int? longueur}){
  if(texte!.length <= longueur!){
    return texte;
  }else{
    int dernierEspace = texte.lastIndexOf(' ', longueur - 4);
    return texte.substring(0, dernierEspace) + '...';
  }
}

void onLoading(BuildContext context){
  showDialog(
      context: context,
      builder: (BuildContext context){
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

Dialog AboutApplication(BuildContext context){
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      padding: EdgeInsets.all(8),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text("Apropos", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.close, color: Colors.blueGrey,),
                ),
              ),
            ],
          ),
          SizedBox(height: 15,),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/logo.jpeg"),
            ),
          ),
          SizedBox(height: 15,),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Text("Cette application a pour but de faciliter la communication et les partages des informations entre les membres!", textAlign: TextAlign.justify, style: style_google.copyWith(fontSize: 15, color: Colors.black38),),
          ),
          Ligne(color: Colors.grey),
          infoAuteur(context, title: "Auteur", subtitle: "RAMANANA Thu Ming Thierry", iconData: Icons.person_2_outlined),
          infoAuteur(context,title: "Adresse email", subtitle: "ramananathumingthierry@gmail.com", iconData: Icons.attach_email_outlined),
          infoAuteur(context,title: "Contact", subtitle: "032 75 637 70", iconData: Icons.phone_outlined),
          infoAuteur(context,title: "Adresse", subtitle: "VT 29 RAI bis Ampahateza", iconData: Icons.local_library_outlined),
          Ligne(color: Colors.grey),
         infoAuteur(context,title: "Version : 1.03.22", subtitle: "copyright @ 2024", iconData: Icons.verified_user),
        ],
      ),
    ),
  );
}

ListTile infoAuteur(BuildContext context, {String? title, String? subtitle, IconData? iconData}){
  return ListTile(
    onTap: (){
      if(title == "Contact"){
        ActionsCallOrMessage(context, subtitle);
      }
    },
    leading: Icon(iconData, color: Colors.blueGrey,),
    title: Text(title!, style: style_google.copyWith(fontWeight: FontWeight.bold),),
    subtitle: Text(subtitle!, style: style_google.copyWith(color: Colors.grey),),
  );
}

String formatTimeAgo(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);

  if (difference.inMinutes < 1) {
    return 'A l\'instant';
  } else if (difference.inMinutes < 60) {
    return '${difference.inMinutes} minute${difference.inMinutes != 1 ? 's' : ''}';
  } else if (difference.inHours < 24) {
    return '${difference.inHours} heure${difference.inHours != 1 ? 's' : ''}';
  } else if (difference.inDays < 7) {
    return '${difference.inDays} jour${difference.inDays != 1 ? 's' : ''}';
  } else if (difference.inDays < 30) {
    return '${(difference.inDays / 7).floor()} semaine${((difference.inDays / 7).floor()) != 1 ? 's' : ''}';
  } else if (difference.inDays < 365) {
    return '${(difference.inDays / 30).floor()} mois${((difference.inDays / 30).floor()) != 1 ? 's' : ''}';
  } else {
    return timeago.format(dateTime, locale: 'fr'); // Utilisation de timeago pour les durées plus longues
  }
}

void onLoadingLogin(BuildContext context, User user){
  showDialog(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 3), () async {
          if(user.status == 0){
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => EnAttente(user: user)), (route) => false);
          }else{
            if(user.roles == "Administrateurs"){
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => AdministrateursScreen(user: user,)), (route) => false);
            }else{
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil(user: user,)), (route) => false);
            }
          }
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