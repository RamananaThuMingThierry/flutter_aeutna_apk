import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/loadingShimmer.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../api/api_response.dart';

class FonctionsScreen extends StatefulWidget {

  const FonctionsScreen({Key? key}) : super(key: key);

  @override
  State<FonctionsScreen> createState() => _FonctionsScreenState();

}

class _FonctionsScreenState extends State<FonctionsScreen> {
  // Déclarations des variables
  List<FonctionModel> _fonctionsList = [];
  int userId = 0;
  bool loading = true;
  int? editFonctions = 0;
  String? recherche;
  TextEditingController nom_fonctions = TextEditingController();
  TextEditingController search = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future _getallFonctions() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllFonctions();

    if(apiResponse.error == null){
      List<dynamic> fonctionsList = apiResponse.data as List<dynamic>;
      List<FonctionModel> fonctions = fonctionsList.map((p) => FonctionModel.fromJson(p)).toList();
      setState(() {
        search.clear();
        _fonctionsList = fonctions;
        loading = false;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  Future _searchFonctions(String? search) async{
    userId = await getUserId();
    ApiResponse apiResponse = await searchFonctions(search);
    if(apiResponse.error == null){
      List<dynamic> fonctionList = apiResponse.data as List<dynamic>;
      List<FonctionModel> fonctions = fonctionList.map((p) => FonctionModel.fromJson(p)).toList();
      setState(() {
        _fonctionsList = fonctions;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _createFonctions() async {
    ApiResponse apiResponse = await createFonctions(fonctions: nom_fonctions.text);
    setState(() {
      editFonctions = 0;
      nom_fonctions.clear();
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallFonctions();
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _updateFonctions() async{
    ApiResponse apiResponse = await updateFonctions(fonctionId: editFonctions, fonctions: nom_fonctions.text);
    setState(() {
      editFonctions = 0;
      nom_fonctions.clear();
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallFonctions();
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == info) {
      Navigator.pop(context);
      MessageInformation(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else {
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _deleteFonctions(int fonctionId) async{
    ApiResponse apiResponse = await deleteFonctions(fonctionId);
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallFonctions();
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  @override
  void initState() {
    _getallFonctions();
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
          }, icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.account_tree, color: Colors.blueGrey,))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Fonctions", style: style_google),
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
                          _getallFonctions();
                        }else{
                          _searchFonctions(recherche);
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
                  _getallFonctions();
                }, icon: Icon(Icons.close, color: Colors.grey,)),
              ],
            ),
          ),
          Expanded(
            child:  loading
                ?
            LoadingShimmer()
                :
            RefreshIndicator(
              onRefresh: (){
                return _getallFonctions();
              },
              child: _fonctionsList.length == 0
                      ?
                  Center(
                    child: Text("Aucun résultat", style: style_google.copyWith(color: Colors.white, fontSize: 18),),
                  )
                      :
              ListView.builder(
                  itemCount: _fonctionsList.length,
                  itemBuilder: (BuildContext context, int index){
                    FonctionModel fonctions = _fonctionsList![index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      color: Colors.white,
                      child: ListTile(
                        leading: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100),
                        ),
                          child: Text("${fonctions.fonctions!.substring(0, 1).toUpperCase()}", style: TextStyle(color: Colors.white),),
                        ),
                        title: Text("${fonctions.fonctions}", style: style_google.copyWith(color: Colors.black87,)),
                        trailing: PopupMenuButton(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.more_vert, color: Colors.black,),
                          ),
                          onSelected: (valeur){
                            if(valeur == "Modifier"){
                              // Modifier
                              print("Modifier");
                              setState(() {
                                editFonctions = fonctions.id;
                                nom_fonctions.text = fonctions.fonctions! ?? "";
                              });
                              showDialog(context: context, builder: (BuildContext context) => fonctionsForm(context, editFonctions));
                            }else{
                              // Supprimer
                              print("Supprimer");
                              showDialog(context: context, builder: (BuildContext context){
                                return confirmationSuppresion(fonctions.id!);
                              });
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              value: "Modifier",
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.lightBlue,),
                                  SizedBox(width: 10,),
                                  Text("Modifier", style: style_google.copyWith(color: Colors.lightBlue)),
                                ]
                                ,
                              ),
                            ),
                            PopupMenuItem(
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red,),
                                  SizedBox(width: 10,),
                                  Text("Supprimer", style: style_google.copyWith(color: Colors.red)),
                                ]
                                ,
                              ),
                              value: "Supprimer",
                            )
                          ],
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          setState(() {
            editFonctions = 0;
            nom_fonctions.clear();
          });
          showDialog(context: context, builder: (BuildContext context) => fonctionsForm(context, editFonctions));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  AlertDialog confirmationSuppresion(int? fonctionId){
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Voulez-vous vraiment le supprimer?",textAlign: TextAlign.center, style: style_google.copyWith(fontSize: 20),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Annuler", style: style_google,)),
        TextButton(onPressed: (){
          _deleteFonctions(fonctionId!);
        }, child: Text("Supprimer", style: style_google.copyWith(color: Colors.red),)),
      ],
    );
  }

  Dialog fonctionsForm(BuildContext context, int? editFonction){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0)
              ),
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${editFonctions == 0 ? "Ajouter" : "Modifier"} une fonction", style: style_google.copyWith(fontSize: 17, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      editFonctions = 0;
                      nom_fonctions.clear();
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.close, color: Colors.blueGrey,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: nom_fonctions,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Veuillez remplir ce champ!";
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Nom fonction",
                    suffixIcon: Icon(Icons.card_travel),
                    hintStyle: TextStyle(color: Colors.blueGrey),
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
                ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                if(_formKey.currentState!.validate()){
                  editFonctions == 0
                  ? _createFonctions()
                  : _updateFonctions();
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Center(
                  child: Text(editFonction == 0 ? "Enregistre" : "Modifier", style: style_google.copyWith(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
