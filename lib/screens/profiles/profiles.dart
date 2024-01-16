import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/avis/nous_contactez.dart';
import 'package:aeutna/screens/messages/messages.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/WidgetListTitle.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  String? id,pseudo,nom,prenom,roles, email, genre, niveau, facebook, adresse, contact,lieu_naissance, image,numero_carte, filiere, cin, axes, sympathisant, date_naissance, contact_personnel, contact_parent;
  int? status;

  @override
  void initState() {
    data = widget.user;
    pseudo = data!.pseudo;
    email = data!.email;
    contact_personnel = data!.contact;
    adresse = data!.adresse;
    roles = data!.roles;
    status = data!.status;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text("Profiles"),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          child: Column(
            children: [
              Card(
                elevation: 0,
                shape: Border(left: BorderSide(width: 5, color: Colors.blueGrey)),
                child: Container(
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: status == 0 ?  200 : 145,
                        child: CircleAvatar(
                          maxRadius: 65,
                          backgroundImage: AssetImage("assets/photo.png"),
                        ),
                      ),
                        showComptePersonnels(pseudo: pseudo, email: email, adresse: adresse, contact: contact_personnel, roles: roles, status: status),
                        status == 1 ? showInformationPersonnels(pseudo: pseudo,nom: nom, prenom: prenom, genre: genre, cin: cin, date_naissance: date_naissance, lieu_naissance: lieu_naissance) : SizedBox(),
                        status == 1 ? showInformationsAEUTNA(numero_carte_aeutna: numero_carte,email: email, facebook: facebook,contact: contact_personnel, filiere: filiere, axes: axes, adresse: adresse, sympathisant: sympathisant, niveau: niveau) : SizedBox()
                    ],
                  ),
                ),
              ),
              WidgetListTitle(title: "Apropos", leading: Icons.info_outlined, trailing: Icons.chevron_right, onTap: () => () => _apropos(context)),
              WidgetListTitle(title: "Avis", leading: Icons.chat_outlined, trailing: Icons.chevron_right, onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => NousContactez()))),
              FiltreAll(),
              WidgetListTitle(title: "Messages", leading: Icons.message, trailing: Icons.chevron_right, onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => Messages ()))),
              WidgetListTitle(title: "Paramètres", leading: Icons.settings_outlined, trailing: Icons.chevron_right, onTap: () => () => Parametre(context, data)),
              WidgetListTitle(title: "Déconnections", leading: Icons.logout_outlined, trailing: Icons.chevron_right, onTap: () => () => deconnectionAlertDialog(context)),
            ],
          ),
        ),
      )
    );
  }

  Widget FiltreAll(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2),
      child: Card(
        shape: Border(left: BorderSide(width: 5, color: Colors.blueGrey)),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              iconColor: Colors.blueGrey,
              backgroundColor: Colors.white,
              title:  Text("Filtres", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
              leading: Icon(Icons.pageview_outlined, color: Colors.grey,),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ligne(color: Colors.blueGrey),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: InkWell(
                    onTap: (){

                    },
                    child: Row(
                      children: [
                        RichText(text: TextSpan(children: [
                          WidgetSpan(child: Icon(Icons.local_library, color: Colors.grey,)),
                          TextSpan(text: "         Axes", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15)),
                        ]))
                      ],
                    ),
                  ),
                ),
                Ligne(color: Colors.blueGrey,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: InkWell(
                    onTap: (){

                    },
                    child: Row(
                      children: [
                        RichText(text: TextSpan(children: [
                          WidgetSpan(child: Icon(Icons.card_travel, color: Colors.grey,)),
                          TextSpan(text: "         Filières", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15)),
                        ]))
                      ],
                    ),
                  ),
                ),
              ]
          ),
        ),
      ),
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
            title:  Text("Compte", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
            leading: Icon(Icons.menu, color: Colors.blueGrey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              _textTitre(titre: "Pseudo"),
              _CardText(iconData: Icons.account_box_rounded, value: pseudo),
              _textTitre(titre: "Adresse e-mail"),
              _CardText(iconData: Icons.account_box_rounded, value: email),
              _textTitre(titre: "Contact"),
              _CardText(iconData: Icons.phone, value: contact),
              _textTitre(titre: "Roles"),
              _CardText(iconData: Icons.person, value: roles),
              _textTitre(titre: "Status"),
              _CardText(iconData: status == 1 ? Icons.credit_card_outlined : Icons.credit_card_off_outlined, value: status == 1 ? "Membres" : "En attente"),
            ]
        ),
      ),
    );
  }

  Widget showInformationPersonnels({String? pseudo,String? nom, String? prenom, String? genre, String? cin, String? date_naissance, String? lieu_naissance}){
    return Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            iconColor: Colors.blueGrey,
            backgroundColor: Colors.white,
            title:  Text("Information Personnel", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
            leading: Icon(Icons.menu, color: Colors.blueGrey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              _textTitre(titre: "Pseudo"),
              _CardText(iconData: Icons.account_box_rounded, value: pseudo),
              _textTitre(titre: "Nom"),
              _CardText(iconData: Icons.account_box_rounded, value: nom),
              _textTitre(titre: "Prénom"),
              _CardText(iconData: Icons.account_box_rounded, value: prenom),
              _textTitre(titre: "Genre"),
              _CardText(iconData: Icons.person, value: genre),
              _textTitre(titre: "C.I.N"),
              _CardText(iconData: Icons.credit_card_outlined, value: cin),
              _textTitre(titre: "Date de naissance"),
              _CardText(iconData: Icons.calendar_month, value: genre),
              _textTitre(titre: "Lieu de naissance"),
              _CardText(iconData: Icons.location_city, value: lieu_naissance),
            ]
        ),
      ),
    );
  }

  Widget showInformationsAEUTNA({String? numero_carte_aeutna,String? email,String? contact, String? facebook, String? axes, String? sympathisant, String? filiere, String? niveau, String? adresse}){
    return Container(
      color: Colors.white,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
            backgroundColor: Colors.white,
            title:  Text("Informations AEUTNA", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
            leading: Icon(Icons.menu, color: Colors.blueGrey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textTitre(titre: "Numéro carte"),
              _CardText(iconData: Icons.confirmation_num, value: numero_carte_aeutna),
              _textTitre(titre: "Adresse e-mail"),
              _CardText(iconData: Icons.mail, value: email),
              _textTitre(titre: "Contact"),
              _CardText(iconData: Icons.phone, value: contact),
              _textTitre(titre: "Adresse"),
              _CardText(iconData: Icons.location_on, value: adresse),
              _textTitre(titre: "Facebook"),
              _CardText(iconData: Icons.facebook, value: facebook),
              _textTitre(titre: "Axes"),
              _CardText(iconData: Icons.local_library, value: axes),
              _textTitre(titre: "Filières"),
              _CardText(iconData: Icons.medical_information, value: filiere),
              _textTitre(titre: "Niveau"),
              _CardText(iconData: Icons.list_outlined, value: niveau),
              _textTitre(titre: "Sympathisant(e)"),
              _CardText(iconData: Icons.confirmation_num_outlined, value: sympathisant),
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
        hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
        prefixIcon: Icon(iconData, color: Colors.blueGrey, size: 20,),
      ),
      textInputAction: TextInputAction.search,
      textAlignVertical: TextAlignVertical.center,
    );
  }

  void deconnectionAlertDialog(BuildContext context){
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext buildContext){
          return AlertDialog(
            title: Text("Déconnection", textAlign:TextAlign.center,style: TextStyle(color: Colors.blueGrey),),
            content: SizedBox(
              height: 80,
              child: Column(
                children: [
                  Ligne(color: Colors.blueGrey,),
                  SizedBox(height: 5,),
                  Text("Voulez-vous vraiment vous déconnecter?", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
                  SizedBox(height: 5,),
                ],
              ),
            ),
            contentPadding: EdgeInsets.only(top: 10.0, left: 5.0, right: 5.0),
            actions: [
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    print("Annuler");
                  },
                  child: Text("Annuler", style: TextStyle(color: Colors.redAccent),)),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    onLoading(context);
                  }, child: Text("Ok",style: TextStyle(color: Colors.blueGrey),)),
            ],
          );
        });
  }

  void onLoading(BuildContext context){
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
                  CircularProgressIndicator(color: Colors.green,),
                  SizedBox(height: 16,),
                  Text("Déconnection...", style: TextStyle(color: Colors.grey),)
                ],
              ),
            ),
          );
        });
  }

  Parametre(BuildContext context,User? data){
    showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        builder: (ctx){
          return Container(
            height: 260,
            color: Colors.blueGrey,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.settings, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text("Paramètres", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                  ],
                ),
                Ligne(color: Colors.white,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.language, color: Colors.white,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        print("Change la langue");
                      }, child:  Text("Change la langue", style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.collections, color: Colors.white,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                        print("Change le thème");
                      }, child:  Text("Change le thème", style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.password_sharp, color: Colors.white,),
                      SizedBox(width: 10,),
                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, child:  Text("Changer le mot de passe", style: TextStyle(color: Colors.white),),)
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
                      }, child:  Text("Modifier le profil", style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                ),
              ],
            ),
          );
        });
  }

  Future _apropos(BuildContext context){
    return showModalBottomSheet(context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
        ),
        backgroundColor: Colors.blueGrey,
        builder: (ctx){
          return Container(
            height: 175,
            child: Column(
              children: [
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.info_outlined, color: Colors.white,),
                    SizedBox(width: 10,),
                    Text("Apropos", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15),),
                  ],
                ),
                Ligne(color: Colors.white,),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: RichText(text: TextSpan(children: [
                    WidgetSpan(child: Text("A.E.U.T.N.A", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                    TextSpan(text: " est une Association des Etudiants à l'Université de Tananarivo Natifs d'Antalaha.", style: TextStyle(color: Colors.white,)),
                  ])),
                ),
                Spacer(),
                Ligne(color: Colors.white),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Version : 1.25.1", style: TextStyle(color: Colors.white, fontSize: 15),),
                  ],
                ),
                SizedBox(height: 10,),
              ],
            ),
          );
        });
  }

  Padding _textTitre({String? titre}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        children: [
          Text("${titre}", style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
