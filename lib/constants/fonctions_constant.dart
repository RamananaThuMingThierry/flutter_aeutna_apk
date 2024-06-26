import 'dart:ui';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/admin/administrateurs.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/enattente.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:fluttertoast/fluttertoast.dart';

TextStyle style_google = GoogleFonts.k2d(color: Colors.blueGrey);

String formatPhoneNumber(String phoneNumber) {
  return phoneNumber.replaceAllMapped(
    RegExp(r'^(\d{3})(\d{2})(\d{3})(\d{2})$'),
        (Match m) => '${m[1]} ${m[2]} ${m[3]} ${m[4]}',
  );
}

void showToast({int? count, String? message_count_null, String? message_count_one,String? message_count_many}) {
  Fluttertoast.showToast(
    msg: "${count == 0
        ? message_count_null
        : count == 1
        ? message_count_one
        : message_count_many}",
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.CENTER,
    backgroundColor: Colors.blueGrey,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

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
                child: Text("A propos", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
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
         infoAuteur(context,title: "Version : 2.19.24", subtitle: "copyright @ 2024", iconData: Icons.verified_user),
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
    return 'Il y a ${difference.inHours} heure${difference.inHours != 1 ? 's' : ''}';
  } else if (difference.inDays < 7) {
    return 'Il y a ${difference.inDays} jour${difference.inDays != 1 ? 's' : ''}';
  } else if (difference.inDays < 30) {
    return 'Il y a ${(difference.inDays / 7).floor()} semaine${((difference.inDays / 7).floor()) != 1 ? 's' : ''}';
  } else if (difference.inDays < 365) {
    return 'Il y a ${(difference.inDays / 30).floor()} mois${((difference.inDays / 30).floor()) != 1 ? 's' : ''}';
  } else {
    return timeago.format(dateTime, locale: 'fr'); // Utilisation de timeago pour les durées plus longues
  }
}

void onLoadingLogin(BuildContext context, User user){

  showDialog(
      context: context,
      builder: (BuildContext context){
        Future.delayed(Duration(seconds: 3), () async {
          if(int.parse(user.status!) == 0){
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

Dialog ShowImages(BuildContext context, String? images){
  return Dialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16)
    ),
    elevation: 0,
    backgroundColor: Colors.transparent,
    child: Container(
      width: double.infinity,
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
                child: Text("Images", style: TextStyle(color: Colors.blueGrey, fontSize: 15),),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  alignment: Alignment.centerRight,
                  child: Icon(Icons.close, color: Colors.blueGrey,),
                ),
              ),
            ],
          ),
          ClipRRect(// rayon des coins arrondis
            child:  Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: images!, // URL de l'image
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  width: double.infinity, // Largeur de l'image
                  height: 350, // Hauteur de l'image
                  fit: BoxFit.cover, // Ajustement de l'image
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}