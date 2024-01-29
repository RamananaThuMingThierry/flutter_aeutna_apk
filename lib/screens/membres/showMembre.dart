import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/axes.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShowMembres extends StatefulWidget {
  Membres? membres;

  ShowMembres({this.membres});

  @override
  State<ShowMembres> createState() => _ShowMembresState();
}

class _ShowMembresState extends State<ShowMembres> {

  Membres? membre;
  Axes? axes;
  Filieres? filieres;
  Niveau? niveau;
  FonctionModel? fonctionModel;
  int? compte = 0;
  @override

  void initState() {
    membre = widget.membres;
    getAxes();
    getFilieres();
    getNiveau();
    getFonctions();
    super.initState();
  }

  void getAxes() async{
    ApiResponse apiResponse = await showAxes(membre!.axes_id!);
    if(apiResponse.error == null){
      setState(() {
        compte = compte! + 1;
        axes = apiResponse.data as Axes?;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void getFilieres() async{

    ApiResponse apiResponse = await showFilieres(membre!.filieres_id!);

    if(apiResponse.error == null){

      setState(() {
        compte = compte! + 1;
        filieres = apiResponse.data as Filieres?;
      });

    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void getNiveau() async{

    ApiResponse apiResponse = await showNiveau(membre!.levels_id!);

    if(apiResponse.error == null){
      setState(() {
        compte = compte! + 1;
        niveau = apiResponse.data as Niveau?;
      });

    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void getFonctions() async{
    ApiResponse apiResponse = await showFonctions(membre!.fonctions_id!);
    if(apiResponse.error == null){
      setState(() {
        compte = compte! + 1;
        fonctionModel = apiResponse.data as FonctionModel?;
      });

    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
          icon: Icon(Icons.arrow_back, color: Colors.blueGrey,),
        ),
        actions: [
          compte != 4 ? SizedBox() : IconButton(onPressed: (){
            ContactezNous(numero: "${membre!.contact_personnel}", action: "tel");
          }, icon: Icon(Icons.call, color: Colors.blueGrey,)),
          compte != 4 ? SizedBox() :IconButton(onPressed: (){
            ContactezNous(numero: "${membre!.contact_personnel}", action: "sms");
          }, icon: Icon(Icons.sms, color: Colors.blueGrey,)),
          compte != 4 ? SizedBox() : membre!.lien_membre_id == 0 ? SizedBox() : IconButton(onPressed: (){

          }, icon: Icon(Icons.email, color: Colors.blueGrey,)),
        ],
      ),
      body:
      compte == 0
          ? SpinKitCircle(
              color: Colors.blueGrey,
              size: 50,
            )
          :
      compte == 1
          ? SpinKitCircle(
              color: Colors.blueGrey,
              size: 50,
            )
          :
      compte == 2
          ?
          SpinKitCircle(
            color: Colors.blueGrey,
            size: 50,
          )
          :
      compte == 3
          ?
      SpinKitCircle(
        color: Colors.blueGrey,
        size: 50,
      )
          :
      SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(250), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(60), // Image radius
                      child: Image.asset('assets/photo.png', fit: BoxFit.cover),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Numéro Carte", style: TextStyle(color: Colors.blueGrey,fontSize: 14),),
                      Text("${membre!.numero_carte}", style: TextStyle(color: Colors.blueGrey,fontSize: 50),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10,),
            membre!.lien_membre_id == 0 ? SizedBox() : Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  children: [
                    Container(
                      width: 350,
                      child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                          ),
                          onPressed: (){},
                          icon: Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          label: Text("Envoyer un message", style: TextStyle(color: Colors.white),),
                    ),
                    ),
                  ],
                ),
            ),
            SizedBox(height: 15,),
            TextTitre(name: "Nom"),
            CardText(context, iconData: Icons.account_box_rounded, value: "${membre!.nom}"),
            SizedBox(height: 10,),
            TextTitre(name: "Prénom"),
            CardText(context, iconData: Icons.account_box_rounded, value: "${membre!.prenom}"),
            SizedBox(height: 10,),
            TextTitre(name: "Date de naissance"),
            CardText(context, iconData: Icons.date_range, value: "${DateFormat.yMMMd('fr').format(DateTime.parse(membre!.date_de_naissance!)) }"),
            SizedBox(height: 10,),TextTitre(name: "Lieu de naissance"),
            CardText(context, iconData: Icons.local_library_sharp, value: "${membre!.lieu_de_naissance}"),
            SizedBox(height: 10,),
            TextTitre(name: "Genre"),
            CardText(context, iconData: membre!.genre == "Masculin" ? Icons.man : Icons.woman, value: "${membre!.genre}"),
            SizedBox(height: 10,),
            TextTitre(name: "C.I.N"),
            CardText(context, iconData: Icons.credit_card_rounded, value: "${membre!.cin}"),
            SizedBox(height: 10,),
            TextTitre(name: "Fonctions"),
            CardText(context, iconData: Icons.account_tree, value: "${fonctionModel!.fonctions}"),
            SizedBox(height: 10,),
            TextTitre(name: "Filières"),
            CardText(context, iconData: Icons.account_tree, value: "${filieres!.nom_filieres!}"),
            SizedBox(height: 10,),
            TextTitre(name: "Niveau"),
            CardText(context, iconData: Icons.stacked_bar_chart_sharp, value: "${niveau!.niveau}"),
            SizedBox(height: 10,),
            TextTitre(name: "Contact Personnel"),
            GestureDetector(child: CardText(context, iconData: Icons.phone_outlined, value: "${membre!.contact_personnel}"), onTap: (){
              ContactezNous(numero: "${membre!.contact_personnel}", action: "tel");
            },),
            SizedBox(height: 10,),
            TextTitre(name: "Contact Tuteur"),
            GestureDetector(child: CardText(context, iconData: Icons.phone, value: "${membre!.contact_tutaire}"), onTap: (){
              ContactezNous(numero: "${membre!.contact_tutaire}", action: "tel");
            },),
            SizedBox(height: 10,),
            TextTitre(name: "Adresse"),
            CardText(context, iconData: Icons.location_city, value: "${membre!.adresse}"),
            SizedBox(height: 10,),
            TextTitre(name: "Facebook"),
            CardText(context, iconData: Icons.credit_card_rounded, value: "${membre!.facebook}"),
            SizedBox(height: 10,),
            TextTitre(name: "Sympathisant(e)"),
            CardText(context, iconData: Icons.account_tree, value: "${membre!.symapthisant == 0 ? "Non" : "Oui"}"),
            SizedBox(height: 10,),
            TextTitre(name: "Axes"),
            CardText(context, iconData: Icons.account_tree, value: "${axes!.nom_axes!}"),
            SizedBox(height: 10,),
            TextTitre(name: "Date d'inscription"),
            CardText(context, iconData: Icons.date_range_outlined, value: "${DateFormat.yMMMMEEEEd('fr').format(DateTime.parse(membre!.date_inscription!)) }"),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(child: TextButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.lightBlue)
                      ),
                      onPressed: (){
                        print("Modifier");
                      }, icon: Icon(Icons.edit, color: Colors.white,), label: Text("Modifier", style: GoogleFonts.roboto(color: Colors.white),))),
                  SizedBox(width: 5,),
                  Expanded(child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red)
                      ),
                      onPressed: (){
                        print("Supprimer");
                      }, icon: Icon(Icons.delete, color: Colors.white,), label: Text("Supprimer", style: GoogleFonts.roboto(color: Colors.white),))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Padding TextTitre({String? name}){
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18),
    child: Row(
      children: [
        Text("${name}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
      ],
    ),
  );
}

Widget CardText(BuildContext context, {IconData? iconData, String? value}){
  return TextFormField(
    enabled: false,
    style: TextStyle(color: Colors.blueGrey),
    onFieldSubmitted: (arg){},
    decoration: InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintText: "${value}",
      hintStyle: TextStyle(color: Colors.blueGrey),
      prefixIcon: Icon(iconData, color: Colors.blueGrey, size: 20,),
    ),
    textAlignVertical: TextAlignVertical.center,
  );
}