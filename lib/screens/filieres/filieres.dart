import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/donnees_vide.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../api/api_response.dart';

class FilieresScreen extends StatefulWidget {

  const FilieresScreen({Key? key}) : super(key: key);

  @override
  State<FilieresScreen> createState() => _FilieresScreenState();

}

class _FilieresScreenState extends State<FilieresScreen> {
  // Déclarations des variables
  List<Filieres> _filieresList = [];
  int userId = 0;
  bool loading = true;
  String? nom_filieres;
  TextEditingController recherche = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future _getallFilieres() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllFilieres();

    if(apiResponse.error == null){
      List<dynamic> filieresList = apiResponse.data as List<dynamic>;
      List<Filieres> filieres = filieresList.map((p) => Filieres.fromJson(p)).toList();
      setState(() {
        recherche.clear();
        _filieresList = filieres;
        loading = false;
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
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  void _createFiliere() async {
    ApiResponse apiResponse = await createFilieres(nom_filieres: nom_filieres);
    if(apiResponse.error == null){
      Navigator.pop(context);
      _getallFilieres();
    }else if(apiResponse.error == unauthorized){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
    }else{
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  @override
  void initState() {
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
        title: Text("Filières", style: TextStyle(color: Colors.blueGrey),),
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
                          controller: recherche,
                          style: TextStyle(color: Colors.blueGrey),
                          onChanged: (value){
                            setState(() {
                              recherche.text = value;
                            });
                            if(recherche.text.isEmpty){
                              _getallFilieres();
                            }else{
                              _searchFilieres(recherche.text);
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
                    recherche.text.isEmpty ?
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
                    ? Center(
                  child: CircularProgressIndicator(color: Colors.blueGrey,),
                )
                    : RefreshIndicator(
                  onRefresh: (){
                    return _getallFilieres();
                  },
                  child: _filieresList.length == 0
                      ?
                      Center(
                        child: Text("Aucun résultat", style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 18),),
                      )
                      :ListView.builder(
                      itemCount: _filieresList.length,
                      itemBuilder: (BuildContext context, int index){
                        Filieres filieres = _filieresList![index];
                        return Card(
                          margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                          color: Colors.white,
                          child: ListTile(
                            leading: Icon(Icons.card_travel),
                            title: Text("${filieres.nom_filieres}", style: TextStyle(color: Colors.blueGrey),),
                            trailing: Icon(Icons.more_vert),
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
          showDialog(context: context, builder: (BuildContext context) => filiereForm(context));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Dialog filiereForm(BuildContext context){
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
                Text("Ajouter un niveau", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
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
                child: MyTextFieldForm(
                    name: "Nom filière",
                    onChanged: () => (value){
                      setState(() {
                        nom_filieres = value;
                      });
                    }, validator: () => (value){
                  if(value == ""){
                    return "Veuillez remplir ce champ!";
                  }
                }, iconData: Icons.stacked_bar_chart_sharp,
                    textInputType: TextInputType.text,
                    edit: false,
                    value: "")
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                if(_formKey.currentState!.validate()){
                  _createFiliere();
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
                  child: Text("Enregistre", style: TextStyle(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
