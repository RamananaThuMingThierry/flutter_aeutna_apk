import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/donnees_vide.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:aeutna/models/axes.dart';
import 'package:flutter/material.dart';

class AxesScreen extends StatefulWidget {
  const AxesScreen({Key? key}) : super(key: key);

  @override
  State<AxesScreen> createState() => _AxesState();
}

class _AxesState extends State<AxesScreen> {
  // Déclarations des variables
  List<Axes> _axesList = [];
  int userId = 0;
  bool loading = true;
  String? nom_axes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future _getallAxes() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllAxes();

    print("Nous sommes iciiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii! ${apiResponse.data}");

    if(apiResponse.error == null){
      List<dynamic> axesList = apiResponse.data as List<dynamic>;
      List<Axes> axes = axesList.map((p) => Axes.fromJson(p)).toList();
      setState(() {
        _axesList = axes;
        loading = loading ? !loading : loading;
      });
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  void _createAxes() async {
    ApiResponse apiResponse = await createAxes(nom_axes: nom_axes);
    if(apiResponse.error == null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil()), (route) => false);
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
    _getallAxes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.local_library))
        ],
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text("Axes"),
      ),
      body: loading
          ? DonneesVide()
          : RefreshIndicator(
            onRefresh: (){
              return _getallAxes();
            },
            child: ListView.builder(
             itemCount: _axesList.length,
              itemBuilder: (BuildContext context, int index){
               Axes axes = _axesList![index];
               return Card(
                 child: ListTile(
                   leading: Icon(Icons.local_library_rounded),
                   title: Text("${axes.nom_axes}"),
                   trailing: Icon(Icons.more_vert),
                 ),
               );
              }),
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showDialog(context: context, builder: (BuildContext context) => axesForm(context));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  Dialog axesForm(BuildContext context){
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
                Text("Ajouter un axe", style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 15),),
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
                    name: "Nom axes",
                    onChanged: () => (value){
                      setState(() {
                        nom_axes = value;
                      });
                    }, validator: () => (value){
                      if(value == ""){
                        return "Veuillez remplir ce champ!";
                      }
                }, iconData: Icons.local_library_rounded,
                    textInputType: TextInputType.text,
                    edit: false,
                    value: "")
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: (){
                if(_formKey.currentState!.validate()){
                  _createAxes();
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


