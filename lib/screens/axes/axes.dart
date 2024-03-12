import 'dart:io';
import 'dart:typed_data';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/loadingShimmer.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/membres/axes_membres.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/donnees_vide.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:aeutna/models/axes.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class AxesScreen extends StatefulWidget {
  User? user;
  AxesScreen({required this.user});

  @override
  State<AxesScreen> createState() => _AxesState();
}

class _AxesState extends State<AxesScreen> {
  // Déclarations des variables
  User? user;
  List<Axes> _axesList = [];
  int userId = 0;
  bool loading = true;
  String? recherche;
  int? editAxes = 0;
  TextEditingController nom_axes = TextEditingController();
  TextEditingController search = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _getallAxes() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllAxes();
    setState(() {
      nom_axes.clear();
      search.clear();
      editAxes = 0;
    });
    if(apiResponse.error == null){
      List<dynamic> axesList = apiResponse.data as List<dynamic>;
      List<Axes> axes = axesList.map((p) => Axes.fromJson(p)).toList();
      setState(() {
        _axesList = axes;
        loading = false;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  Future _searchAxes(String? search) async{
    userId = await getUserId();
    ApiResponse apiResponse = await searchAxes(search);
    if(apiResponse.error == null){
      List<dynamic> axesList = apiResponse.data as List<dynamic>;
      List<Axes> axes = axesList.map((p) => Axes.fromJson(p)).toList();
      setState(() {
        _axesList = axes;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }


  void _createAxes() async {
    ApiResponse apiResponse = await createAxes(nom_axes: nom_axes.text);
    setState(() {
      nom_axes.clear();
      editAxes = 0;
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallAxes();
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

  void _updateAxes() async{
    ApiResponse apiResponse = await updateAxes(axesId: editAxes, nom_axes: nom_axes.text);

    setState(() {
      editAxes = 0;
      nom_axes.clear();
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context,"${apiResponse.data}");
      _getallAxes();
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

  void _deleteAxes(int axesId) async{
    ApiResponse apiResponse = await deleteAxes(axesId);
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallAxes();
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
    _getallAxes();
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
          IconButton(
              onPressed: (){
                downloadPDF();
              },
              icon: Icon(Icons.picture_as_pdf, color: Colors.blueGrey,))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Axes", style: style_google,),
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
                          _getallAxes();
                        }else{
                          _searchAxes(recherche);
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
                  _getallAxes();
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
                return _getallAxes();
              },
              child: _axesList.length == 0
                  ?
              Center(
                child: Text("Aucun résultat", style: style_google.copyWith(fontSize: 18, color: Colors.white),),
              )
                  :
              ListView.builder(
                  itemCount: _axesList.length,
                  itemBuilder: (BuildContext context, int index){
                    Axes axes = _axesList![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => AxesMembres(axes_id: axes.id, user: user,)));
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                        color: Colors.white,
                        child: ListTile(
                          leading:  Container(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                          color: Colors.blueGrey,
                          borderRadius: BorderRadius.circular(100),
                          ),
                           child: Text("${axes.nom_axes!.substring(0, 1).toUpperCase()}", style: TextStyle(color: Colors.white),),
                          ),
                          title: Text("${axes.nom_axes}", style: style_google.copyWith(color: Colors.black87),),
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
                                  editAxes = axes.id;
                                  nom_axes.text = axes.nom_axes! ?? "";
                                });
                                showDialog(context: context, builder: (BuildContext context) => axesForm(context, editAxe: editAxes));
                              }else{
                                // Supprimer
                                print("Supprimer");
                                showDialog(context: context, builder: (BuildContext context){
                                  return confirmationSuppresion(axes.id!);
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
          _getallAxes();
          showDialog(context: context, builder: (BuildContext context) => axesForm(context, editAxe: editAxes));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Future<void> downloadPDF() async {

    String token = await getToken();

    var response = await http.get(Uri.parse("${axesURL}_export"), headers: {
      'Accept': 'application/json',
      'Authorization' : 'Bearer $token'
    });

    print("status ------------> ${response.body}");

    if (response.statusCode == 200) {
      var dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/users.pdf');
      await file.writeAsBytes(response.bodyBytes);
    } else {
      throw Exception('Erreur lors du téléchargement du PDF');
    }
  }

  AlertDialog confirmationSuppresion(int? axesId){
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Voulez-vous vraiment le supprimer?",textAlign: TextAlign.center, style: style_google.copyWith(fontSize: 20),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Annuler", style: style_google,)),
        TextButton(onPressed: (){
          _deleteAxes(axesId!);
        }, child: Text("Supprimer", style: style_google.copyWith(color: Colors.red),)),
      ],
    );
  }

  Dialog axesForm(BuildContext context, {int? editAxe}){
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
                Text("${editAxes == 0 ? "Ajouter" : "Modifier"} un axe", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
                GestureDetector(
                  onTap: (){
                    setState(() {
                      nom_axes.clear();
                      editAxes = 0;
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
                  controller: nom_axes,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Veuillez remplir ce champ!";
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Nom axes",
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
                  editAxes == 0
                  ? _createAxes()
                  : _updateAxes();
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
                  child: Text(editAxes == 0 ? "Enregistre" : "Modifier", style:style_google.copyWith(color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


