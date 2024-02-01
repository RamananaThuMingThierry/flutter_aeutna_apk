import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/admin/adminPageLoading.dart';
import 'package:aeutna/screens/admin/class/Drawer.dart';
import 'package:aeutna/screens/admin/class/Pages.dart';
import 'package:aeutna/screens/avis/avis.dart';
import 'package:aeutna/screens/axes/axes.dart';
import 'package:aeutna/screens/filieres/filieres.dart';
import 'package:aeutna/screens/fonctions/fonctions.dart';
import 'package:aeutna/screens/membres/membres.dart';
import 'package:aeutna/screens/message%20groupe/message_groupe.dart';
import 'package:aeutna/screens/niveau/niveau.dart';
import 'package:aeutna/screens/post/publication.dart';
import 'package:aeutna/screens/utilisateurs/users.dart';
import 'package:aeutna/screens/utilisateurs/utilisateurs_en_attentes.dart';
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
   Pages("Avis", Icons.question_mark_outlined),
   Pages("Publications", Icons.post_add),
   Pages("Axes", Icons.local_library_sharp),
   Pages("Niveau", Icons.stacked_bar_chart),
   Pages("Filières", Icons.card_travel),
   Pages("Fonctions", Icons.account_tree),
   Pages("Membres", Icons.credit_card_rounded),
   Pages("Message Groupes", Icons.message_outlined),
   Pages("Utilisateurs En attente", Icons.people_alt_outlined),
   Pages("Utilisateurs", Icons.people),
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
        title: Text("Administrations", style: style_google.copyWith(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
        elevation: 1,
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.dark_mode, color: Colors.blueGrey,)),
          IconButton(onPressed: (){}, icon: Icon(Icons.notifications_none, color: Colors.blueGrey,)),
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
                   radius: 20,
                    backgroundImage: image == null ? AssetImage("assets/photo.png") : NetworkImage(image!) as ImageProvider,
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
              ListTile(
                leading: Icon(Icons.home_outlined, color: Colors.blueGrey,),
                title: Text("Accueil", style: style_google,),
                onTap: (){},
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.person_2_outlined, color: Colors.blueGrey,),
                title: Text("Profiles", style: style_google,),
                onTap: (){},
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.settings_outlined, color: Colors.blueGrey,),
                title: Text("Paramètre", style: style_google,),
                onTap: (){},
              ),
              Ligne(color: Colors.grey,),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.blueGrey,),
                title: Text("Déconnection", style: style_google,),
                onTap: (){},
              ),
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
                            if(page.nom == "Avis"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => AvisScreen()));
                            }else if(page.nom == "Publications"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => Publication(user: data!,)));
                            }else if(page.nom == "Axes"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => AxesScreen()));
                            }else if(page.nom == "Niveau"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => NiveauScreen()));
                            }else if(page.nom == "Filières"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => FilieresScreen()));
                            }else if(page.nom == "Fonctions"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => FonctionsScreen()));
                            }else if(page.nom == "Membres"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => MembresScreen()));
                            }else if(page.nom == "Message Groupes"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => MessagesGroupes()));
                            }else if(page.nom == "Utilisateurs En attente"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => UtilisateursEnAttentes()));
                            }else if(page.nom == "Utilisateurs"){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => UsersScreen()));
                            }
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(page.iconData, size: 40, color: Colors.blueGrey,),
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
