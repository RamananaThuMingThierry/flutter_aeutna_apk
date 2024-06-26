import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/axes.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/historiques/historiques.dart';
import 'package:aeutna/screens/profiles/updateProfile.dart';
import 'package:aeutna/screens/statistiques/statistiques.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/widgets/WidgetListTitle.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Profiles extends StatefulWidget {
  User? user;

  Profiles({required this.user});

  @override
  State<Profiles> createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {

  // Déclarations des variables
  User? data;
  bool edit = false;
  Membres? membres;
  Axes? axes;
  Filieres? filieres;
  Niveau? niveau;
  FonctionModel? fonctionModel;

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  String? id,pseudo,nom,prenom,roles, email, genre, facebook, adresse, etablissement, contact,lieu_naissance, image,numero_carte, filiere, cin, sympathisant, date_naissance, contact_personnel, contact_parent, status;

  @override
  void initState() {
    data = widget.user;
    pseudo = data!.pseudo;
    email = data!.email;
    contact_personnel = data!.contact;
    adresse = data!.adresse;
    roles = data!.roles;
    // status = int.parse(data!.status!);
    status = data!.status!;
    image = data!.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(onPressed: () => Parametre(context, data), icon: Icon(Icons.settings_outlined, color: Colors.grey,))
        ],
        backgroundColor: Colors.transparent
      ),
      body: SingleChildScrollView(
        child:Container(
          width: double.infinity,
          child: Column(
            children: [
              Card(
                elevation: 0,
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: status == 0 ?  200 : 145,
                        child: CircleAvatar(
                          radius: 70,
                          backgroundColor: Colors.blueGrey,
                          child: GestureDetector(
                            onTap: () {
                              if(image != null){
                                showDialog(context: context, builder: (BuildContext context) => ShowImages(context, image!));
                              }
                            },
                            child: CircleAvatar(
                              radius: 65,
                              backgroundColor: Colors.grey, // Couleur de fond par défaut
                              child: image != null
                                  ? CachedNetworkImage(
                                imageUrl: image!,
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
                                  : Icon(Icons.person, size: 80,color: Colors.black54,), // Widget par défaut si imageUrl est null
                            ),
                          ),
                        ),
                      ),
                        SizedBox(height: 20,),
                        showComptePersonnels(
                            pseudo: pseudo,
                            email: email,
                            adresse: adresse,
                            contact: contact_personnel,
                            roles: roles,
                            status: int.parse(status!)),
                    ],
                  ),
                ),
              ),
              WidgetListTitle(
                  title: "A-propos",
                  leading: Icons.info_outlined,
                  trailing: Icons.chevron_right,
                  onTap: () => () => showDialog(context: context, builder: (BuildContext context) => AboutApplication(context))
              ),
              WidgetListTitle(
                  title: "Historiques",
                  leading: Icons.history_edu_rounded,
                  trailing: Icons.chevron_right,
                  onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => HistoriquesScreen()))
              ),
              WidgetListTitle(
                  title: "Statistiques",
                  leading: Icons.area_chart_outlined,
                  trailing: Icons.chevron_right,
                  onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => StatistiquesScreen()))
              ),
              WidgetListTitle(title: "Contactez-nous", leading: Icons.help, trailing: Icons.chevron_right, onTap: () => (){ ActionsCallOrMessage(context, "0327563770");}),
              WidgetListTitle(title: "Déconnections", leading: Icons.logout_outlined, trailing: Icons.chevron_right, onTap: () => () => deconnectionAlertDialog(context)),
            ],
          ),
        ),
      )
    );
  }

  Widget showComptePersonnels({String? pseudo,String? email,String? adresse, String? contact, String? roles,int? status}){
    return Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            iconColor: Colors.blueGrey,
            backgroundColor: Colors.white,
            title:  Text("Mon compte", style: style_google,),
            leading: Icon(Icons.newspaper, color: Colors.grey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              _textTitre(titre: "Pseudo"),
              _CardText(iconData: Icons.account_box_rounded, value: pseudo),
              _textTitre(titre: "Adresse e-mail"),
              _CardText(iconData: Icons.account_box_rounded, value: email),
              _textTitre(titre: "Contact"),
              GestureDetector(
                  onTap: () => ActionsCallOrMessage(context, contact),
                  child: _CardText(iconData: Icons.phone, value: contact)),
              _textTitre(titre: "Rôles"),
              _CardText(iconData: Icons.person, value: roles),
              _textTitre(titre: "Status"),
              _CardText(iconData: status == 1 ? Icons.fact_check : Icons.query_builder, value: status == 1 ? "Membres" : "En attente"),
            ]
        ),
      ),
    );
  }

  Widget showInformationPersonnels({String? nom, String? prenom, String? genre, String? cin, String? date_naissance, String? lieu_naissance}){
    return Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            iconColor: Colors.blueGrey,
            backgroundColor: Colors.white,
            title:  Text("Information Personnel", style: style_google,),
            leading: Icon(Icons.credit_card_outlined, color: Colors.grey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              _textTitre(titre: "Nom"),
              _CardText(iconData: Icons.account_box_rounded, value: nom),
              _textTitre(titre: "Prénom"),
              _CardText(iconData: Icons.account_box_rounded, value: prenom ?? '-'),
              _textTitre(titre: "Genre"),
              _CardText(iconData: Icons.person, value: genre),
              _textTitre(titre: "C.I.N"),
              _CardText(iconData: Icons.credit_card_outlined, value: separerParEspace(cin.toString())),
              _textTitre(titre: "Date de naissance"),
             _CardText(iconData: Icons.calendar_month, value: "${ date_naissance == "" ? "" : DateFormat.yMMMd('fr').format(DateTime.parse(date_naissance!)) }"),
              _textTitre(titre: "Lieu de naissance"),
              _CardText(iconData: Icons.location_city, value: lieu_naissance),
            ]
        ),
      ),
    );
  }

  Widget showInformationsAEUTNA({
    int? numero_carte_aeutna,
    String? email,
    String? contact,
    String? facebook,
    String? contact_tutaire,
    String? axes,
    int? sympathisant,
    String? filiere,
    String? niveau,
    String? fonction,
    String? adresse,
    String? date_inscription}){
    return Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            backgroundColor: Colors.white,
            title:  Text("Informations AEUTNA", style: style_google,),
            leading: Icon(Icons.credit_card_outlined, color: Colors.grey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textTitre(titre: "Numéro carte"),
              _CardText(iconData: Icons.confirmation_num, value: "${numero_carte_aeutna}"),
              _textTitre(titre: "Fonctions"),
              _CardText(iconData: Icons.mail, value: fonction),
              _textTitre(titre: "Contact Personnel"),
              GestureDetector(
                  onTap: () => ActionsCallOrMessage(context, contact),
                  child: _CardText(iconData: Icons.phone, value: contact)),
              _textTitre(titre: "Contact Tuteur"),
              GestureDetector(
                  onTap: () => ActionsCallOrMessage(context, contact_tutaire),
                  child: _CardText(iconData: Icons.phone_outlined, value: contact_tutaire)),
              _textTitre(titre: "Adresse"),
              _CardText(iconData: Icons.location_on, value: adresse),
              _textTitre(titre: "Facebook"),
              _CardText(iconData: Icons.facebook, value: facebook),
              _textTitre(titre: "Axes"),
              _CardText(iconData: Icons.local_library, value: "${axes}"),
              _textTitre(titre: "Filières"),
              _CardText(iconData: Icons.medical_information, value: "${filiere}"),
              _textTitre(titre: "Niveau"),
              _CardText(iconData: Icons.list_outlined, value: "${niveau}"),
              _textTitre(titre: "Sympathisant(e)"),
              _CardText(iconData: Icons.confirmation_num_outlined, value: sympathisant == 0 ? "false" : "true"),
              _textTitre(titre: "Date d'inscription"),
              _CardText(iconData: Icons.date_range_outlined, value: "${ date_inscription == "" ? "" :  DateFormat.yMMMMEEEEd('fr').format(DateTime.parse(date_inscription!)) }"),
            ]
        ),
      ),
    );
  }

  Widget _CardText({IconData? iconData, String? value}){
    return TextFormField(
      enabled: false,
      style: TextStyle(color: Colors.blueGrey),
      onFieldSubmitted: (arg){},
      decoration: InputDecoration(
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        hintText: "${value}",
        hintStyle: style_google.copyWith(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(iconData, color: Colors.blueGrey, size: 20,),
      ),
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  Parametre(BuildContext context,User? data){
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        builder: (ctx){
          return Expanded(
            child: Container(
              color: Colors.blueGrey,
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.settings, color: Colors.white,),
                      SizedBox(width: 10,),
                      Text("Paramètres", style: style_google.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Ligne(color: Colors.white,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.password_sharp, color: Colors.white,),
                        SizedBox(width: 10,),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child:  Text("Changer le mot de passe", style: style_google.copyWith(color: Colors.white)),)
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.account_circle_outlined, color: Colors.white,),
                        SizedBox(width: 10,),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => UpdateProfile(user: data!)));
                        }, child:  Text("Modifier le profil", style: style_google.copyWith(color: Colors.white),),)
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }


  Padding _textTitre({String? titre}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Text("${titre}", style: style_google.copyWith(fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
