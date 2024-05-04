import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/constants/loadingShimmer.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/membres/niveau_membres.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:aeutna/widgets/noResult.dart';
import 'package:flutter/material.dart';

class NiveauScreen extends StatefulWidget {
  User? user;
  NiveauScreen({required this.user});

  @override
  State<NiveauScreen> createState() => _NiveauScreenState();
}

class _NiveauScreenState extends State<NiveauScreen> {
  // Déclarations des variables
  User? user;
  List<Niveau> _niveauList = [];
  int userId = 0;
  bool loading = true;
  String? recherche;
  int? editNiveau = 0;
  TextEditingController nom_niveau = TextEditingController();
  TextEditingController search = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future _getallNiveau() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllNiveau();
    setState(() {
      nom_niveau.clear();
      search.clear();
      editNiveau = 0;
    });
    if(apiResponse.error == null){
      List<dynamic> niveauList = apiResponse.data as List<dynamic>;
      List<Niveau> niveaux = niveauList.map((p) => Niveau.fromJson(p)).toList();
      setState(() {
        search.clear();
        _niveauList = niveaux;
        loading = false;
      });
      showToast(
          count: _niveauList.length,
          message_count_null: "Il n'y a aucun niveau",
          message_count_one: "Il y un seul niveau",
          message_count_many: "Il y a ${_niveauList.length} niveaux"
      );
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
        MessageErreurs(context, apiResponse.error);
    }
  }


  Future _searchNiveaux(String? search) async{
    userId = await getUserId();
    ApiResponse apiResponse = await searchNiveau(search);
    if(apiResponse.error == null){
      List<dynamic> niveauList = apiResponse.data as List<dynamic>;
      List<Niveau> niveaux = niveauList.map((p) => Niveau.fromJson(p)).toList();
      setState(() {
        _niveauList = niveaux;
      });
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, apiResponse.error);
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _createNiveau() async {
    onLoading(context);
    ApiResponse apiResponse = await createNiveau(niveau: nom_niveau.text);
    if(apiResponse.error == null){
      setState(() {
        nom_niveau.clear();
      });
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallNiveau();
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
      ErreurLogin(context);
    }else{
      Navigator.pop(context);
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  void _updateNiveau() async{
    onLoading(context);
    ApiResponse apiResponse = await updateNiveau(niveauId: editNiveau, niveau: nom_niveau.text);
    setState(() {
      editNiveau = 0;
      nom_niveau.clear();
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context,"${apiResponse.data}");
      _getallNiveau();
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

  void _deleteNiveau(int niveauId) async{
    onLoading(context);
    ApiResponse apiResponse = await deleteNiveau(niveauId);
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
      _getallNiveau();
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
        title: Text("Niveau", style: style_google,),
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
                          _getallNiveau();
                        }else{
                          _searchNiveaux(recherche);
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
                  _getallNiveau();
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
                return _getallNiveau();
              },
              child: _niveauList.length == 0
                  ?
              NoResult()
                  :
              ListView.builder(
                  itemCount: _niveauList.length,
                  itemBuilder: (BuildContext context, int index){
                    Niveau niveau = _niveauList![index];
                    return GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (ctx) => NiveauMembres(niveau_id: niveau.id, user: user)));
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
                            child: Text("${niveau.niveau!.substring(0, 1).toUpperCase()}", style: TextStyle(color: Colors.white),),
                          ),
                          title: Text("${niveau.niveau}", style: style_google.copyWith(color: Colors.grey),),
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
                                  editNiveau = niveau.id;
                                  nom_niveau.text = niveau.niveau! ?? "";
                                });
                                showDialog(context: context, builder: (BuildContext context) => niveauForm(context, editNiveau));
                              }else{
                                // Supprimer
                                print("Supprimer");
                                showDialog(context: context, builder: (BuildContext context){
                                  return confirmationSuppresion(niveau.id!);
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
      floatingActionButton: loading == true ? SizedBox() :  FloatingActionButton(
        onPressed: (){
          _getallNiveau();
          setState(() {
            nom_niveau.clear();
            editNiveau = 0;
          });
          showDialog(context: context, builder: (BuildContext context) => niveauForm(context, editNiveau));
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blueGrey,
      ),
    );
  }

  AlertDialog confirmationSuppresion(int? niveauId){
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Text("Voulez-vous vraiment le supprimer?",textAlign: TextAlign.center, style: style_google.copyWith(fontSize: 20),),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text("Annuler", style: style_google,)),
        TextButton(onPressed: (){
          Navigator.pop(context);
          _deleteNiveau(niveauId!);
        }, child: Text("Supprimer", style: style_google.copyWith(color: Colors.red),)),
      ],
    );
  }

  Dialog niveauForm(BuildContext context, int? editNiveau){
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
                Text("${editNiveau == 0 ? "Ajouter" : "Modifier"} un niveau", style: style_google.copyWith(color: Colors.blueGrey, fontSize: 17, fontWeight: FontWeight.bold),),
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
                  controller: nom_niveau,
                  validator: (value){
                    if(value!.isEmpty){
                      return "Veuillez remplir ce champ!";
                    }
                  },
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "Niveau",
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
                  editNiveau == 0
                  ?_createNiveau()
                  :_updateNiveau();
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
                  child: Text(editNiveau == 0 ? "Enregistre" : "Modifier", style:style_google.copyWith(color: Colors.white),),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
