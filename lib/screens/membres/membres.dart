import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/onLoadingMembreShimmer.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/membres/showMembre.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';

class MembresScreen extends StatefulWidget {
  const MembresScreen({Key? key}) : super(key: key);

  @override
  State<MembresScreen> createState() => _MembresState();
}

class _MembresState extends State<MembresScreen> {
  // Déclarations des variables
  String? recherche;
  bool loading = true;
  List<Membres> _membresList = [];

  Future _getallMembres() async{
    ApiResponse apiResponse = await getAllMembres();

    if(apiResponse.error == null){
      List<dynamic> membresList = apiResponse.data as List<dynamic>;
      List<Membres> membres = membresList.map((p) => Membres.fromJson(p)).toList();
      setState(() {
        _membresList = membres;
        loading = loading ? !loading : loading;
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

  @override
  void initState() {
    _getallMembres();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(250), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(23), // Image radius
                child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
              ),
            ),
          )
        ],
        title: Text("MEMBRES A.E.U.T.N.A", style: style_google.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        leading: Icon(Icons.people, color: Colors.blueGrey,),
      ),
      body: Column(
        children: [
          Card(
            elevation: 1,
            shape: Border(
                bottom: BorderSide(color: Colors.grey, width: .5)),
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:3, vertical: 5),
              height: 50,
              child: TextFormField(
                style: TextStyle(color: Colors.blueGrey),
                onChanged: (value){
                  setState(() {
                    recherche = value;
                  });
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
                  suffixIcon: Icon(Icons.search),
                  suffixIconColor: Colors.grey,
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
          Expanded(child: loading
            ?
            OnLoadingMembreShimmer()
            :
            RefreshIndicator(
                onRefresh: (){
                  return _getallMembres();
                },
                  child: ListView.builder(
                      itemCount: _membresList.length,
                      itemBuilder: (BuildContext context, int index){
                        Membres membres = _membresList[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowMembres(membres: membres,)));
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 3,vertical: 2),
                            child: ListTile(
                              leading: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(250), // Image border
                                  child: SizedBox.fromSize(
                                    size: Size.fromRadius(23), // Image radius
                                    child: Image.asset('assets/photo.png', fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              title: Text("${membres.numero_carte}", style: TextStyle(fontSize: 15, color: Colors.blueGrey, fontWeight: FontWeight.bold),),
                              subtitle: Text("${membres.nom} ${membres.prenom}", style: TextStyle(fontSize: 13),),
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
