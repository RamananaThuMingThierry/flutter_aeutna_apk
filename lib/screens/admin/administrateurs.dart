import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/admin/adminPageLoading.dart';
import 'package:aeutna/screens/admin/class/Drawer.dart';
import 'package:aeutna/screens/admin/class/Pages.dart';
import 'package:aeutna/screens/axes/axes.dart';
import 'package:aeutna/screens/filieres/filieres.dart';
import 'package:aeutna/screens/fonctions/fonctions.dart';
import 'package:aeutna/screens/historiques/historiques.dart';
import 'package:aeutna/screens/membres/filtre_membres.dart';
import 'package:aeutna/screens/membres/membres.dart';
import 'package:aeutna/screens/message%20groupe/message_groupe.dart';
import 'package:aeutna/screens/niveau/niveau.dart';
import 'package:aeutna/screens/profiles/profile.dart';
import 'package:aeutna/screens/statistiques/statistiques.dart';
import 'package:aeutna/screens/utilisateurs/users.dart';
import 'package:aeutna/screens/utilisateurs/utilisateurs_en_attentes.dart';
import 'package:aeutna/widgets/itemDrawer.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AdministrateursScreen extends StatefulWidget {
  User user;
  AdministrateursScreen({required this.user});

  @override
  State<AdministrateursScreen> createState() => _AdministrateursScreenState();
}

class _AdministrateursScreenState extends State<AdministrateursScreen> {
 User? data;
 String? pseudo, email, contact, roles, image;
 GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

 List<Pages> pages = [
   Pages("Axes", Icons.local_library_sharp),
   Pages("Fonctions", Icons.account_tree),
   Pages("Filières", Icons.card_travel),
   Pages("Niveau", Icons.stacked_bar_chart),
   Pages("Membres", Icons.credit_card_rounded),
   Pages("Message Groupes", Icons.message_outlined),
   Pages("Utilisateurs En attente", Icons.people_alt_outlined),
   Pages("Utilisateurs", Icons.people),
   Pages("Filtre", Icons.search_outlined),
   Pages("Statistiques", Icons.area_chart),
 ];

 @override
  void initState() {
   data = widget.user;
   pseudo = data!.pseudo ?? "";
   email = data!.email ?? "";
   roles = data!.roles ?? "";
   contact = data!.contact ?? "";
   image = data!.image ?? null;
   super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            _key.currentState!.openDrawer();
          },
          icon: Icon(Icons.menu, color: Colors.black54,),),
        title: Text("AEUTNA", style: style_google.copyWith(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => HistoriquesScreen())),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
                child: CircleAvatar(
                  radius: 15,
                  backgroundImage: AssetImage("assets/logo.jpeg"),
                )
            ),
          )
          //IconButton(onPressed: (){}, icon: Icon(Icons.dark_mode, color: Colors.blueGrey,)),
          //IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none, color: Colors.blueGrey,)),
        ],
      ),
      drawer: ClipPath(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        clipper: OvalRightBorderClipper(),
        child: Drawer(
          width: 275.0,
          child: ListView(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey, // Couleur de fond par défaut
                  child: image != null
                      ? CachedNetworkImage(
                    imageUrl: data!.image!,
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
                      : Icon(Icons.person, color: Colors.black, size: 50,), // Widget par défaut si imageUrl est null
                ),
                  // backgroundImage: (userm!.image == null) ? Image.asset("assets/photo.png").image : Image.network(userm!.image!).image
                accountName: Text("${data!.pseudo ?? "Aucun"}", style: style_google.copyWith(color: Colors.white)),
                accountEmail: Text("${data!.email ?? "Aucun"}", overflow: TextOverflow.ellipsis, style: style_google.copyWith(color: Colors.white)),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/no_image.jpg"),
                        fit: BoxFit.cover
                    )
                ),
              ),
              ItemDrawer(
                  titre: "Acceuil",
                  onTap: () => () => Navigator.pop(context),
                  iconData: Icons.home_outlined),
              Ligne(color: Colors.grey,),
              ItemDrawer(
                titre: "Profiles",
                iconData: Icons.person_2_outlined,
                onTap: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => Profile(user: data!))),
              ),
              Ligne(color: Colors.grey,),
              ItemDrawer(
                  titre: "A propos",
                  onTap: () => (){
                    Navigator.pop(context);
                    showDialog(context: context, builder: (BuildContext context) => AboutApplication(context));
                  },
                  iconData: Icons.info_outlined),
              Ligne(color: Colors.grey,),
              ItemDrawer(
                  titre: "Historiques",
                  onTap: () => () =>  Navigator.push(context, MaterialPageRoute(builder: (ctx) => HistoriquesScreen())),
                  iconData: Icons.history_edu_rounded),
              Ligne(color: Colors.grey,),
              ItemDrawer(
                  titre: "Déconnection",
                  onTap: () => (){
                    Navigator.pop(context);
                    deconnectionAlertDialog(context);
                  },
                  iconData: Icons.logout),
              Ligne(color: Colors.grey,),
            ],
          ),
        ),
      ),
      body: data == null
          ? AdminPageLoading()
          : Center(
              child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  itemCount: pages.length,
                  itemBuilder: (BuildContext context,int index){
                    Pages page = pages[index];
                    return Container(
                      margin: EdgeInsets.all(2),
                      child: Card(
                        shape: Border(),
                        elevation: 1,
                        child: InkWell(
                          onTap: (){
                            if(page.nom == "Filtre"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => Filtre(user: data!,)));
                            }else if(page.nom == "Axes"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => AxesScreen(user: data!,)));
                            }else if(page.nom == "Niveau"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => NiveauScreen(user: data!,)));
                            }else if(page.nom == "Filières"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => FilieresScreen(user: data!,)));
                            }else if(page.nom == "Fonctions"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => FonctionsScreen(user: data!,)));
                            }else if(page.nom == "Membres"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => MembresScreen(user: data!,)));
                            }else if(page.nom == "Message Groupes"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => MessagesGroupes()));
                            }else if(page.nom == "Utilisateurs En attente"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => UtilisateursEnAttentes()));
                            }else if(page.nom == "Utilisateurs"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => UsersScreen()));
                            }else if(page.nom == "Statistiques"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => StatistiquesScreen()));
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(page.iconData, size: 40, color: Colors.grey,),
                              Text("${page.nom}", style: style_google.copyWith(fontWeight: FontWeight.bold),)
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
          ),
    );
  }
}

