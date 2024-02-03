import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/loadingShimmer.dart';
import 'package:aeutna/models/avis.dart';
import 'package:aeutna/screens/avis/showAvis.dart';
import 'package:aeutna/services/avis_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';

class AvisScreen extends StatefulWidget {
  const AvisScreen({Key? key}) : super(key: key);

  @override
  State<AvisScreen> createState() => _AvisScreenState();
}

class _AvisScreenState extends State<AvisScreen> {
  // Déclaration des variables
  List<Avis> _avisList = [];
  int userId = 0;
  bool loading = true;
  String? recherche;
  TextEditingController search = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _getallAvis() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllAvis();
    setState(() {
      search.clear();
    });
    if(apiResponse.error == null){
      List<dynamic> avisList = apiResponse.data as List<dynamic>;
      List<Avis> avis = avisList.map((p) => Avis.fromJson(p)).toList();
      setState(() {
        _avisList = avis;
        loading = false;
      });
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _deleteAvis(int avisId) async{
    ApiResponse apiResponse = await deleteAvis(avisId);
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallAvis();
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }


  @override
  void initState() {
    _getallAvis();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.mail, color: Colors.blueGrey,))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("A.V.I.S", style: style_google,),
      ),
      body: Column(
        children: [
          Card(
            shape: Border(bottom: BorderSide(color: Colors.grey, width: .5)),
            elevation: 1,
            margin: EdgeInsets.all(0),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    height: 50,
                    child: TextFormField(
                      controller: search,
                      style: TextStyle(color: Colors.blueGrey),
                      onChanged: (value){
                        setState(() {
                          recherche = value;
                        });
                        if(recherche!.isEmpty){
                          _getallAvis();
                        }else{
                          print("No code pour l'instant");
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
                  _getallAvis();
                }, icon: Icon(Icons.close, color: Colors.grey,)),
              ],
            ),
          ),
          Expanded(
            child: loading
                ?
            LoadingShimmer()
                :
            RefreshIndicator(
              onRefresh: (){
                return _getallAvis();
              },
              child: _avisList.length == 0
                  ?
              Center(
                child: Text("Aucun résultat", style: style_google.copyWith(fontSize: 18),),
              )
                  :
              ListView.builder(
                  itemCount: _avisList.length,
                  itemBuilder: (BuildContext context, int index){
                    Avis avis = _avisList![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowAvisScreen(avis: avis,)));
                      },
                      onLongPress: (){
                        print("Voulez-vous le supprimer");
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        color: Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            backgroundImage: (avis.user!.image != null ?  NetworkImage("${avis.user!.image}") : AssetImage("assets/photo.png")) as ImageProvider,
                          ),
                          title: Text("${avis.user!.pseudo}", style: style_google.copyWith(color: Colors.black87),),
                          subtitle: Text(ajouterTroisPointSiTextTropLong("${avis.message}", 30)),
                          trailing: Icon(Icons.chevron_right, color: Colors.blueGrey,),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  AlertDialog confirmationSuppresion(int? avisId){
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Voulez-vous vraiment le supprimer?",textAlign: TextAlign.center, style: style_google.copyWith(fontSize: 20),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Annuler", style: style_google,)),
        TextButton(onPressed: (){
          _deleteAvis(avisId!);
        }, child: Text("Supprimer", style: style_google.copyWith(color: Colors.red),)),
      ],
    );
  }
}
