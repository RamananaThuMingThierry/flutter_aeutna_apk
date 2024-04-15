import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/axes.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/models/sections.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/membres/updateMembres.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/sections_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShowMembres extends StatefulWidget {
  Membres? membres;
  User? user;

  ShowMembres({this.membres, this.user});

  @override
  State<ShowMembres> createState() => _ShowMembresState();
}

class _ShowMembresState extends State<ShowMembres> {

  User? user;
  Membres? membre;
  Axes? axes;
  Filieres? filieres;
  Niveau? niveau;
  SectionsModel? sections;
  FonctionModel? fonctionModel;
  int? compte = 0;
  String? axes_null;

  @override
  void initState() {
    membre = widget.membres;
    user = widget.user;

    print("Membres :${membre} et Users : ${user!.pseudo!}");

    if(membre!.axes_id == null){
      axes_null = null;
    }

    getAxes();
    getFilieres();
    getNiveau();
    getFonctions();
    getSections();
    super.initState();
  }

  void getSections() async{
    ApiResponse apiResponse = await showSections(membre!.sections_id!);
    if(apiResponse.error == null){
      setState(() {
        compte = compte! + 1;
        sections = apiResponse.data as SectionsModel?;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void getAxes() async{
    if(membre!.axes_id != null){
      ApiResponse apiResponse = await showAxes(membre!.axes_id!);
      if (apiResponse.error == null) {
        setState(() {
          compte = compte! + 1;
          axes = apiResponse.data as Axes?;
          axes_null = axes!.nom_axes;
        });
      } else if (apiResponse.error == unauthorized) {
        ErreurLogin(context);
      } else {
        MessageErreurs(context, "${apiResponse.error}");
      }
    }else{
      setState(() {
        compte = compte! + 1;
      });
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
          compte != 5 ? SizedBox() : membre!.contact_personnel == null ? SizedBox() : IconButton(onPressed: (){
            ContactezNous(numero: "${membre!.contact_personnel}", action: "tel");
          }, icon: Icon(Icons.call, color: Colors.blueGrey,)),
          compte != 5 ? SizedBox() : membre!.contact_personnel == null ? SizedBox() : IconButton(onPressed: (){
            ContactezNous(numero: "${membre!.contact_personnel}", action: "sms");
          }, icon: Icon(Icons.sms, color: Colors.blueGrey,)),
          SizedBox(width: 10,)
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
      )   :
        compte == 4
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
                CircleAvatar(
                radius: 65,
                backgroundColor: Colors.grey.shade500,
                child:GestureDetector(
                  onTap: () {
                    if(membre!.image != null){
                      showDialog(context: context, builder: (BuildContext context) => ShowImages(context, membre!.image));
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey, // Couleur de fond par défaut
                    child: membre!.image != null
                        ? CachedNetworkImage(
                      imageUrl: membre!.image!,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        : Icon(Icons.person, color: Colors.black,size: 80,), // Widget par défaut si imageUrl est null
                  ),
                )
                ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Numéro Carte", style: style_google,),
                      Text("${membre!.numero_carte}", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 50),),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            TextTitre(name: "Nom"),
            CardText(context, iconData: Icons.account_box_rounded, value: "${membre!.nom}"),
            SizedBox(height: 10,),
            TextTitre(name: "Prénom"),
            CardText(context, iconData: Icons.account_box_rounded, value: "${membre!.prenom ?? "-"}"),
            user!.roles == "Administrateurs"
              ? SizedBox(height: 10,)
              : SizedBox(),
            user!.roles == "Administrateurs"
              ? TextTitre(name: "Date de naissance")
              : SizedBox(),
            user!.roles == "Administrateurs"
                ? CardText(context, iconData: Icons.date_range, value: "${DateFormat.yMMMMd('fr').format(DateTime.parse(membre!.date_de_naissance!)) }")
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? SizedBox(height: 10,)
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? TextTitre(name: "Lieu de naissance")
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? CardText(context, iconData: Icons.add_location, value: "${membre!.lieu_de_naissance}")
                : SizedBox(),
            SizedBox(height: 10,),
            TextTitre(name: "Genre"),
            CardText(context, iconData: membre!.genre == "Masculin" ? Icons.man : Icons.woman, value: "${membre!.genre}"),
            user!.roles == "Administrateurs"
                ? SizedBox(height: 10,)
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? TextTitre(name: "C.I.N")
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? CardText(context, iconData: Icons.credit_card_rounded, value: membre!.cin == "null" ? '-' : separerParEspace("${membre!.cin}"))
                : SizedBox(),
            SizedBox(height: 10,),
            TextTitre(name: "Fonctions"),
            CardText(context, iconData: Icons.account_tree, value: "${fonctionModel!.fonctions}"),
            SizedBox(height: 10,),
            TextTitre(name: "Filières"),
            CardText(context, iconData: Icons.card_travel, value: "${filieres!.nom_filieres!}"),
            SizedBox(height: 10,),
            TextTitre(name: "Niveau"),
            CardText(context, iconData: Icons.stacked_bar_chart_sharp, value: "${niveau!.niveau}"),
            SizedBox(height: 10,),
            TextTitre(name: "Etablissement"),
            CardText(context, iconData: Icons.school_outlined, value: membre!.etablissement == "null" ? '-' : membre!.etablissement),
            SizedBox(height: 10,),
            TextTitre(name: "Contact Personnel"),
            GestureDetector(child: CardText(context, iconData: Icons.phone_outlined, value: "${membre!.contact_personnel}"), onTap: (){
              ActionsCallOrMessage(context, "${membre!.contact_personnel}");
            },),
            SizedBox(height: 10,),
            TextTitre(name: "Contact Tuteur"),
            GestureDetector(child: CardText(context, iconData: Icons.phone, value: "${membre!.contact_tuteur}"), onTap: (){
              ActionsCallOrMessage(context, "${membre!.contact_tuteur}");
              },),
            SizedBox(height: 10,),
            TextTitre(name: "Adresse"),
            CardText(context, iconData: Icons.home_outlined, value: "${membre!.adresse}"),
            SizedBox(height: 10,),
            TextTitre(name: "Sections"),
            CardText(context, iconData: Icons.dashboard_outlined, value: "${sections!.nom_sections}"),
            SizedBox(height: 10,),
            TextTitre(name: "Axes"),
            CardText(context, iconData: Icons.local_library_sharp, value: "${axes_null ?? '-'}"),
            TextTitre(name: "Facebook"),
            GestureDetector(
                onTap: (){
                  membre!.facebook != null ? redirectToFacebook(nom: "${membre!.facebook}"): print("Aucun facebook");
                },
                child: CardText(context, iconData: Icons.facebook_outlined, value: "${membre!.facebook}")),
            user!.roles == "Administrateurs"
                ? SizedBox(height: 10,)
                : SizedBox(),
                TextTitre(name: "Sympathisant(e)"),
                CardText(context, iconData: Icons.account_tree, value: "${membre!.symapthisant == 0 ? "Non" : "Oui"}"),
            user!.roles == "Administrateurs"
                ? SizedBox(height: 10,)
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? SizedBox(height: 10,)
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? TextTitre(name: "Date d'inscription")
                : SizedBox(),
            user!.roles == "Administrateurs"
                ? CardText(context, iconData: Icons.date_range_outlined, value: "${DateFormat.yMMMMEEEEd('fr').format(DateTime.parse(membre!.date_inscription!)) }")
                : SizedBox(),
            user!.roles == "Administrateurs" ? SizedBox(height: 10,) : SizedBox(),
            user!.roles == "Administrateurs" ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Row(
                children: [
                  Expanded(child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red)
                      ),
                      onPressed: (){
                        print("Supprimer");
                      }, icon: Icon(Icons.delete, color: Colors.white,), label: Text("Supprimer", style: GoogleFonts.roboto(color: Colors.white),))),
                  SizedBox(width: 5,),
                  Expanded(child: TextButton.icon(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.lightBlue)
                      ),
                      onPressed: (){
                        Navigator.push(context,MaterialPageRoute(builder: (ctx) => ModifierMembres(membres: membre, user: user,)));
                        print("Modifier");
                      }, icon: Icon(Icons.edit, color: Colors.white,), label: Text("Modifier", style: GoogleFonts.roboto(color: Colors.white),))),
                ],
              ),
            ) : SizedBox()
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
        Text("${name}", style: style_google.copyWith(fontWeight: FontWeight.bold),),
      ],
    ),
  );
}

Widget CardText(BuildContext context, {IconData? iconData, String? value}){
  return TextFormField(
    enabled: false,
    style: style_google.copyWith(color: Colors.grey),
    onFieldSubmitted: (arg){},
    decoration: InputDecoration(
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      hintText: "${value}",
      hintStyle: style_google.copyWith(color: Colors.grey),
      prefixIcon: Icon(iconData, color: Colors.grey, size: 20,),
    ),
    textAlignVertical: TextAlignVertical.center,
  );
}