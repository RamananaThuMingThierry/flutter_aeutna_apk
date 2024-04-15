import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/onLoadingMembreShimmer.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/admin/administrateurs.dart';
import 'package:aeutna/screens/membres/addMembres.dart';
import 'package:aeutna/screens/membres/showMembre.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/widgets/noResult.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class MembresScreen extends StatefulWidget {
  User user;
  MembresScreen({required this.user});

  @override
  State<MembresScreen> createState() => _MembresState();
}

class _MembresState extends State<MembresScreen> {
  // Déclarations des variables
  User? user;
  String? recherche;
  bool loading = true;
  List<Membres> _membresList = [];
  TextEditingController search = TextEditingController();

  Future _searchMembres(String? search) async{
    ApiResponse apiResponse = await searchMembres(search);
    loading = false;
    if(apiResponse.error == null){
      List<dynamic> membresList = apiResponse.data as List<dynamic>;
      List<Membres> membres = membresList.map((p) => Membres.fromJson(p)).toList();
      setState(() {
        _membresList = membres;
        loading = loading ? !loading : loading;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  Future _getallMembres() async{
    ApiResponse apiResponse = await getAllMembres();
    setState(() {
      search.clear();
    });
    if(apiResponse.error == null){
      List<dynamic> membresList = apiResponse.data as List<dynamic>;
      List<Membres> membres = membresList.map((p) => Membres.fromJson(p)).toList();
      setState(() {
        _membresList = membres;
        loading = loading ? !loading : loading;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  @override
  void initState() {
    user = widget.user;
    _getallMembres();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: CircleAvatar(
              radius: 15,
              backgroundImage: AssetImage("assets/logo.jpeg"),
            )
          )
        ],
        title: Text("${_membresList.length < 2 ? '${_membresList.length} - Membre' : '${_membresList.length} - Membres'}", style: style_google.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        leading: user!.roles == "Administrateurs" ?  IconButton(
          onPressed: (){
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => AdministrateursScreen(user: user!,)), (route) => false);
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ) : IconButton(onPressed: (){}, icon: Icon(Icons.people_alt_outlined, color: Colors.blueGrey,)),
      ),
      body: Column(
        children: [
          Card(
            elevation: 1,
            shape: Border(
                bottom: BorderSide(color: Colors.grey, width: .5)),
            margin: EdgeInsets.all(0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal:3, vertical: 5),
                    height: 50,
                    child: TextFormField(
                      controller: search,
                      style: TextStyle(color: Colors.blueGrey),
                      onChanged: (value){
                        setState(() {
                          recherche = value;
                        });
                        if(recherche!.isEmpty){
                          _getallMembres();
                        }else{
                          _searchMembres(recherche);
                        }
                      },
                      validator:(value){
                        if(value == ""){
                          return "Veuillez saisir le nom à recherche";
                        }
                      },
                      decoration: InputDecoration(
                        filled: true,
                        hintText: "Recherche",
                        hintStyle: TextStyle(color: Colors.blueGrey),
                        fillColor: Colors.white,
                        enabledBorder : UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey,
                          ),
                        ),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                ),
                recherche == null ?
                IconButton(
                    onPressed: (){}, icon: Icon(Icons.search_outlined, color: Colors.grey,))
                    :
                IconButton(onPressed: (){
                  _getallMembres();
                }, icon: Icon(Icons.close, color: Colors.grey,)),
              ],
            ),
          ),
          Expanded(child: loading
            ?
            OnLoadingMembreShimmer()
            :
            RefreshIndicator(
                onRefresh: (){
                  return _getallMembres();
                },
                  child: _membresList.length == 0
                      ? NoResult()
                      : ListView.builder(
                      itemCount: _membresList.length,
                      itemBuilder: (BuildContext context, int index){
                        Membres membres = _membresList[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowMembres(membres: membres,user: user,)));
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 3,vertical: 1),
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 7),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundColor: Colors.blueGrey,
                                  child:  CircleAvatar(
                                    radius: 23,
                                    backgroundColor: Colors.grey, // Couleur de fond par défaut
                                    child: membres!.image != null
                                        ? CachedNetworkImage(
                                      imageUrl: membres!.image!,
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
                                        : Icon(Icons.person, size: 30,color: Colors.black,), // Widget par défaut si imageUrl est null
                                  ),
                                ),
                              ),
                              trailing: Icon(Icons.chevron_right_outlined, color: Colors.blueGrey,),
                              title: Text("${membres.numero_carte}", style: TextStyle(fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.bold),),
                              subtitle: Text("${membres.nom} ${membres.prenom ?? ''}", style: TextStyle(fontSize: 13),),
                            ),
                          ),
                        );
                      })
              )
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: user!.roles == "Administrateurs" ? FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => AddMembresScreen(user: user!,)));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ): SizedBox(),
    );
  }
}
