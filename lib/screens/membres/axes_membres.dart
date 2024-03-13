import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/onLoadingMembreShimmer.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/membres/showMembre.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AxesMembres extends StatefulWidget {
  int? axes_id;
  User? user;
  AxesMembres({required this.axes_id, required this.user});

  @override
  State<AxesMembres> createState() => _AxesMembresState();
}

class _AxesMembresState extends State<AxesMembres> {
  int? axes_id;
  User? user;

  String? recherche;
  bool loading = true;
  List<Membres> _membresList = [];
  TextEditingController search = TextEditingController();

  Future _getallAxesMembres() async{
    ApiResponse apiResponse = await filtreMembresParAxes(axes_id);
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

  Future _searchMembres(String? search) async{
    ApiResponse apiResponse = await searchMembresAxes(search, axes_id);
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

  @override
  void initState() {
    user = widget.user;
    axes_id = widget.axes_id;
    _getallAxesMembres();
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
        title: Text("Membres", style: style_google.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        )
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
                          _getallAxesMembres();
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
                  _getallAxesMembres();
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
                return _getallAxesMembres();
              },
              child: _membresList.length == 0
                  ? Center(child: Text("Aucun membre", style: style_google.copyWith(color: Colors.white),),)
                  : ListView.builder(
                  itemCount: _membresList.length,
                  itemBuilder: (BuildContext context, int index){
                    Membres membres = _membresList[index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowMembres(membres: membres,user: user,)));
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                        child: ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                            child: CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blueGrey,
                              child:  CircleAvatar(
                                radius: 21,
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
                                    : Icon(Icons.person), // Widget par défaut si imageUrl est null
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
    );
  }
}
