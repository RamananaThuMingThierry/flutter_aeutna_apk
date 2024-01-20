import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/donnees_vide.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';

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
  String? fonctions;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future _getallFonctions() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllFonctions();

    print("Nous sommes iciiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii! ${apiResponse.data}");

    if(apiResponse.error == null){
      List<dynamic> fonctionsList = apiResponse.data as List<dynamic>;
      List<FonctionModel> fonctions = fonctionsList.map((p) => FonctionModel.fromJson(p)).toList();
      setState(() {
        _fonctionsList = fonctions;
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

  void _createFonctions() async {
    ApiResponse apiResponse = await createFonctions(fonctions: fonctions);
    if(apiResponse.error == null){
      Navigator.pop(context);
      _getallFonctions();
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
    _getallFonctions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.card_travel))
        ],
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text("Fonctions"),
      ),
      body: loading
          ? DonneesVide()
          : RefreshIndicator(
        onRefresh: (){
          return _getallFonctions();
        },
        child: ListView.builder(
            itemCount: _fonctionsList.length,
            itemBuilder: (BuildContext context, int index){
              FonctionModel fonctions = _fonctionsList![index];
              return Card(
                child: ListTile(
                  leading: Icon(Icons.card_travel),
                  title: Text("${fonctions.fonctions}"),
                  trailing: Icon(Icons.more_vert),
                ),
              );
            }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context) => fonctionsForm(context));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Dialog fonctionsForm(BuildContext context){
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
                Text("Ajouter une fonction", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
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
                    name: "Nom Fonctions",
                    onChanged: () => (value){
                      setState(() {
                        fonctions = value;
                      });
                    }, validator: () => (value){
                  if(value == ""){
                    return "Veuillez remplir ce champ!";
                  }
                }, iconData: Icons.card_travel,
                    textInputType: TextInputType.text,
                    edit: false,
                    value: "")
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                if(_formKey.currentState!.validate()){
                  _createFonctions();
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
