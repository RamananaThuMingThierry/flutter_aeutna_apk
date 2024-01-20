import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';

class NiveauScreen extends StatefulWidget {
  const NiveauScreen({Key? key}) : super(key: key);

  @override
  State<NiveauScreen> createState() => _NiveauScreenState();
}

class _NiveauScreenState extends State<NiveauScreen> {
  // Déclarations des variables
  List<Niveau> _niveauList = [];
  int userId = 0;
  bool loading = true;
  String? niveau;
  String? recherche;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future _getallNiveau() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllNiveau();

    if(apiResponse.error == null){
      List<dynamic> niveauList = apiResponse.data as List<dynamic>;
      List<Niveau> niveaux = niveauList.map((p) => Niveau.fromJson(p)).toList();
      setState(() {
        _niveauList = niveaux;
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

  void _createNiveau() async {
    ApiResponse apiResponse = await createNiveau(niveau: niveau);
    if(apiResponse.error == null){
      Navigator.pop(context);
      _getallNiveau();
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
    _getallNiveau();
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
          IconButton(onPressed: (){}, icon: Icon(Icons.stacked_bar_chart_sharp, color: Colors.blueGrey,))
        ],
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Niveau", style: TextStyle(color: Colors.blueGrey),),
      ),
      body: Column(
        children: [
          Card(
            shape: Border(bottom: BorderSide(color: Colors.grey, width: .5)),
            elevation: 2,
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              height: 50,
              child: MyTextFieldForm(
                name: "Recherche...",
                onChanged: () => (value){
                  setState(() {
                    recherche = value;
                  });
                },
                validator: () => (value){
                  if(value == ""){
                    return "Veuillez saisir le nom à recherche";
                  }
                },
                edit: false,
                textInputType: TextInputType.text,
                value: "", iconData: Icons.search,
              ),
              color: Colors.white,
            ),
          ),
          Expanded(
            child: loading
                ? Center(
              child: CircularProgressIndicator(color: Colors.blueGrey,),
            )
                : RefreshIndicator(
              onRefresh: (){
                return _getallNiveau();
              },
              child: ListView.builder(
                  itemCount: _niveauList.length,
                  itemBuilder: (BuildContext context, int index){
                    Niveau niveau = _niveauList![index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(Icons.card_travel),
                        title: Text("${niveau.niveau}"),
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
          showDialog(context: context, builder: (BuildContext context) => niveauForm(context));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Dialog niveauForm(BuildContext context){
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
                Text("Ajouter un filière", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
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
                    name: "Niveau",
                    onChanged: () => (value){
                      setState(() {
                        niveau = value;
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
                  _createNiveau();
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
