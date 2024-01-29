import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/axes.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/avis/avis.dart';
import 'package:aeutna/screens/avis/nous_contactez.dart';
import 'package:aeutna/screens/axes/axes.dart';
import 'package:aeutna/screens/filieres/filieres.dart';
import 'package:aeutna/screens/fonctions/fonctions.dart';
import 'package:aeutna/screens/message%20groupe/message_groupe.dart';
import 'package:aeutna/screens/niveau/niveau.dart';
import 'package:aeutna/screens/profiles/apropos.dart';
import 'package:aeutna/screens/utilisateurs/users.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/WidgetListTitle.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  String? id,pseudo,nom,prenom,roles, email, genre, facebook, adresse, contact,lieu_naissance, image,numero_carte, filiere, cin, sympathisant, date_naissance, contact_personnel, contact_parent;
  int? status;

  void getAxes() async{
    ApiResponse apiResponse = await showAxes(membres!.axes_id!);
    if(apiResponse.error == null){
      setState(() {
        axes = apiResponse.data as Axes?;
      });
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  void getFilieres() async{

    ApiResponse apiResponse = await showFilieres(membres!.filieres_id!);

    if(apiResponse.error == null){

      setState(() {
        filieres = apiResponse.data as Filieres?;
      });

    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  void getNiveau() async{

    ApiResponse apiResponse = await showNiveau(membres!.levels_id!);

    if(apiResponse.error == null){
      setState(() {
        niveau = apiResponse.data as Niveau?;
      });

    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  void getFonctions() async{
    ApiResponse apiResponse = await showFonctions(membres!.fonctions_id!);
    if(apiResponse.error == null){
      setState(() {
        fonctionModel = apiResponse.data as FonctionModel?;
      });

    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  Future getMembre() async{

    ApiResponse apiResponse = await getMembres(widget.user!.id!);

    if(apiResponse.error == null){

      print(apiResponse.data);
      if(apiResponse.data == null){
        membres == null;
      }else{
        setState(() {
          membres = apiResponse.data as Membres;
        });
        getAxes();
        getFilieres();
        getFonctions();
        getNiveau();
      }
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  @override
  void initState() {
    data = widget.user;
    pseudo = data!.pseudo;
    email = data!.email;
    contact_personnel = data!.contact;
    adresse = data!.adresse;
    roles = data!.roles;
    status = data!.status;
    if(status == 1){
      getMembre();
    }
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
          IconButton(onPressed: () => Parametre(context, data), icon: Icon(Icons.menu, color: Colors.black45,))
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
                          maxRadius: 65,
                          backgroundImage: AssetImage("assets/photo.png"),
                        ),
                      ),
                        SizedBox(height: 20,),
                        showComptePersonnels(
                            pseudo: pseudo,
                            email: email,
                            adresse: adresse,
                            contact: contact_personnel,
                            roles: roles,
                            status: status),
                        status == 1 ? showInformationPersonnels(
                            nom: membres == null ? "" : membres!.nom,
                            prenom: membres == null ? "" : membres!.prenom,
                            genre: membres == null ? "" : membres!.genre,
                            cin: membres == null ? "" : membres!.cin,
                            date_naissance: membres == null ? "" : membres!.date_de_naissance,
                            lieu_naissance: membres == null ? "" : membres!.lieu_de_naissance
                        ) : SizedBox(),
                        status == 1 ? showInformationsAEUTNA(
                            contact_tutaire: membres == null ? "" : membres!.contact_tutaire,
                            numero_carte_aeutna: membres == null ? 0 : membres!.numero_carte ,
                            email: email,
                            filiere: filieres == null ? "" : filieres!.nom_filieres,
                            facebook: membres == null ? "" : membres!.facebook,
                            contact: contact_personnel,
                            adresse: adresse,
                            fonction: fonctionModel == null ? "" : fonctionModel!.fonctions,
                            niveau: niveau == null ? "" : niveau!.niveau,
                            axes: axes == null ? "" : axes!.nom_axes,
                            sympathisant: membres == null ? 0 : membres!.symapthisant,
                            date_inscription: membres == null ? "" : membres!.date_inscription,
                        ) : SizedBox()
                    ],
                  ),
                ),
              ),
              WidgetListTitle(title: "Messages Groupe", leading: Icons.message_rounded, trailing: Icons.chevron_right, onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => MessagesGroupes ()))),
              WidgetListTitle(title: "Message Membres", leading: Icons.mail_rounded, trailing: Icons.chevron_right, onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => AvisScreen()))),
              WidgetListTitle(title: "Avis", leading: Icons.question_mark_outlined, trailing: Icons.chevron_right, onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => NousContactez()))),
              FiltreAll(),
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
        elevation: 0,
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
              iconColor: Colors.blueGrey,
              backgroundColor: Colors.white,
              title:  Text("Menu", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
              leading: Icon(Icons.menu, color: Colors.grey,),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Ligne(color: Colors.transparent),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: InkWell(
                    onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => AxesScreen()));
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
                Ligne(color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => FonctionsScreen()));
                    },
                    child: Row(
                      children: [
                        RichText(text: TextSpan(children: [
                          WidgetSpan(child: Icon(Icons.account_tree, color: Colors.grey,)),
                          TextSpan(text: "         Fonctions", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15)),
                        ]))
                      ],
                    ),
                  ),
                ),
                Ligne(color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: InkWell(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => FilieresScreen()));
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
                Ligne(color: Colors.transparent,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: InkWell(
                    onTap: (){
                       Navigator.push(context, MaterialPageRoute(builder: (ctx) => NiveauScreen()));
                    },
                    child: Row(
                      children: [
                        RichText(text: TextSpan(children: [
                          WidgetSpan(child: Icon(Icons.stacked_bar_chart_sharp, color: Colors.grey,)),
                          TextSpan(text: "         Niveau", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15)),
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
            title:  Text("Mon compte", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
            leading: Icon(Icons.newspaper, color: Colors.grey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              _textTitre(titre: "Pseudo"),
              _CardText(iconData: Icons.account_box_rounded, value: pseudo),
              _textTitre(titre: "Adresse e-mail"),
              _CardText(iconData: Icons.account_box_rounded, value: email),
              _textTitre(titre: "Contact"),
              _CardText(iconData: Icons.phone, value: contact),
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
            title:  Text("Information Personnel", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
            leading: Icon(Icons.credit_card_outlined, color: Colors.grey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            childrenPadding: EdgeInsets.symmetric(horizontal: 10),
            children: [
              _textTitre(titre: "Nom"),
              _CardText(iconData: Icons.account_box_rounded, value: nom),
              _textTitre(titre: "Prénom"),
              _CardText(iconData: Icons.account_box_rounded, value: prenom),
              _textTitre(titre: "Genre"),
              _CardText(iconData: Icons.person, value: genre),
              _textTitre(titre: "C.I.N"),
              _CardText(iconData: Icons.credit_card_outlined, value: cin),
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
            title:  Text("Informations AEUTNA", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
            leading: Icon(Icons.credit_card_outlined, color: Colors.grey,),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _textTitre(titre: "Numéro carte"),
              _CardText(iconData: Icons.confirmation_num, value: "${numero_carte_aeutna}"),
              _textTitre(titre: "Fonctions"),
              _CardText(iconData: Icons.mail, value: fonction),
              _textTitre(titre: "Contact Personnel"),
              _CardText(iconData: Icons.phone, value: contact),
              _textTitre(titre: "Contact Tuteur"),
              _CardText(iconData: Icons.phone_outlined, value: contact_tutaire),
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
            backgroundColor: Colors.white,
            content: SizedBox(
              height: 65,
              child: Column(
                children: [
                  SizedBox(height: 20,),
                  Text("Vous déconnecter de votre compte?", textAlign: TextAlign.center,style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 17),),
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
                  child: Text("Annuler", style: TextStyle(color: Colors.lightBlue),)),
              TextButton(
                  onPressed: (){
                    Navigator.pop(context);
                    onLoadingDeconnection(context);
                  }, child: Text("Se déconnecter",style: TextStyle(color: Colors.redAccent),)),
            ],
          );
        });
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
                      Text("Paramètres", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
                    ],
                  ),
                  Ligne(color: Colors.white,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outlined, color: Colors.white,),
                        SizedBox(width: 10,),
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                          Apropos(context);
                        }, child:  Text("Apropos", style: TextStyle(color: Colors.white),),)
                      ],
                    ),
                  ),
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
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.people, color: Colors.white,),
                        SizedBox(width: 10,),
                        TextButton(onPressed: (){
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => UsersScreen()), (route) => false);
                        }, child:  Text("Listes des utilisateurs", style: TextStyle(color: Colors.white),),)
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
          Text("${titre}", style: TextStyle(color: Colors.blueGrey, fontSize: 15, fontWeight: FontWeight.bold),),
        ],
      ),
    );
  }
}
