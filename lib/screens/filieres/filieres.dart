import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/loadingShimmer.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/membres/filiere_membres.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/donnees_vide.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/noResult.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/api_response.dart';

class FilieresScreen extends StatefulWidget {
  User? user;
  FilieresScreen({required this.user});

  @override
  State<FilieresScreen> createState() => _FilieresScreenState();

}

class _FilieresScreenState extends State<FilieresScreen> {
  // Déclarations des variables
  User? user;
  List<Filieres> _filieresList = [];
  int userId = 0;
  bool loading = true;
  int? editFiliere = 0;
  TextEditingController nom_filieres = TextEditingController();
  String? recherche;
  TextEditingController search = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _getallFilieres() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllFilieres();

    if(apiResponse.error == null){
      List<dynamic> filieresList = apiResponse.data as List<dynamic>;
      List<Filieres> filieres = filieresList.map((p) => Filieres.fromJson(p)).toList();
      setState(() {
        search.clear();
        _filieresList = filieres;
        loading = false;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  Future _searchFilieres(String? search) async{
    userId = await getUserId();
    ApiResponse apiResponse = await searchFilieres(search);
    if(apiResponse.error == null){
      List<dynamic> filieresList = apiResponse.data as List<dynamic>;
      List<Filieres> filieres = filieresList.map((p) => Filieres.fromJson(p)).toList();
      setState(() {
        _filieresList = filieres;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _createFiliere() async {
    onLoading(context);
    ApiResponse apiResponse = await createFilieres(nom_filieres: nom_filieres.text);
    if(apiResponse.error == null){
      Navigator.pop(context);
      setState(() {
        nom_filieres.clear();
      });
      MessageReussi(context, "${apiResponse.data}");
      _getallFilieres();
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, apiResponse.error);
      ErreurLogin(context);
    }else{
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _updateFilieres() async{
    onLoading(context);
    ApiResponse apiResponse = await updateFilieres(filiereId: editFiliere, nom_filieres: nom_filieres.text);
    setState(() {
      editFiliere = 0;
      nom_filieres.clear();
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context,"${apiResponse.data}");
      _getallFilieres();
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == info){
      Navigator.pop(context);
      MessageInformation(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else {
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _deleteFilieres(int filiereId) async{
    onLoading(context);
    ApiResponse apiResponse = await deleteFilieres(filiereId);
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallFilieres();
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
    user = widget.user;
    _getallFilieres();
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
          IconButton(onPressed: (){}, icon: Icon(Icons.card_travel, color: Colors.blueGrey,))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Filières", style: style_google),
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
                              _getallFilieres();
                            }else{
                              _searchFilieres(recherche);
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
                      _getallFilieres();
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
                    return _getallFilieres();
                  },
                  child: _filieresList.length == 0
                      ?NoResult()
                      :ListView.builder(
                      itemCount: _filieresList.length,
                      itemBuilder: (BuildContext context, int index){
                        Filieres filieres = _filieresList![index];
                        return GestureDetector(
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => FiliereMembres(filiere_id: filieres.id, user: user))),
                          child: Card(
                            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                            color: Colors.white,
                            child: ListTile(
                              leading: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Text("${filieres.nom_filieres!.substring(0, 1).toUpperCase()}", style: TextStyle(color: Colors.white),),
                              ),
                              title: Text("${filieres.nom_filieres!}", style: TextStyle(color: Colors.grey),),
                              trailing: PopupMenuButton(
                                      child: Padding(
                                        padding: EdgeInsets.only(right: 10),
                                        child: Icon(Icons.more_vert, color: Colors.blueGrey,),
                                      ),
                                      onSelected: (valeur){
                                        if(valeur == "Modifier"){
                                          // Modifier
                                          print("Modifier");
                                          setState(() {
                                            editFiliere = filieres.id;
                                            nom_filieres.text = filieres.nom_filieres! ?? "";
                                          });
                                          showDialog(context: context, builder: (BuildContext context) => filiereForm(context, editFiliere));
                                        }else{
                                          // Supprimer
                                          print("Supprimer");
                                          showDialog(context: context, builder: (BuildContext context){
                                            return confirmationSuppresion(filieres.id!);
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
                                                Text("Modifier", style: GoogleFonts.roboto(color: Colors.lightBlue)),
                                              ]
                                           ,
                                        ),
                                        ),
                                        PopupMenuItem(
                                          child: Row(
                                            children: [
                                              Icon(Icons.delete, color: Colors.red,),
                                              SizedBox(width: 10,),
                                              Text("Supprimer", style: GoogleFonts.roboto(color: Colors.red)),
                                            ]
                                            ,
                                          ),
                                          value: "Supprimer",
                                        )
                                      ],
                                    )
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: loading == true ? SizedBox() : FloatingActionButton(
        onPressed: (){
          _getallFilieres();
          setState(() {
            nom_filieres.clear();
            editFiliere = 0;
          });
          showDialog(context: context, builder: (BuildContext context) => filiereForm(context, editFiliere));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  AlertDialog confirmationSuppresion(int? filiereId){
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Voulez-vous vraiment le supprimer?", style: GoogleFonts.roboto(color: Colors.grey),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Annuler")),
        TextButton(onPressed: (){
          Navigator.pop(context);
          _deleteFilieres(filiereId!);
        }, child: Text("Supprimer", style: TextStyle(color: Colors.red),)),
      ],
    );
  }

  Dialog filiereForm(BuildContext context, int? editFiliere){
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
                Text("${editFiliere == 0 ? "Ajouter" : "Modifier"} un filière", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 17),),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
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
                  style: style_google,
                  controller: nom_filieres,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Veuillez remplir ce champ!";
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Nom filière",
                    suffixIcon: Icon(Icons.card_travel),
                    hintStyle: style_google,
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
                  Navigator.pop(context);
                  editFiliere == 0
                  ? _createFiliere()
                  : _updateFilieres();
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
                  child: Text(editFiliere == 0 ? "Enregistre" : "Modifier", style: style_google.copyWith(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
