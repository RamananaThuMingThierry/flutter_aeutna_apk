import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/axes.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/models/sections.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/membres/result_filitre_membres.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/sections_services.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';

class Filtre extends StatefulWidget {
  User? user;
  Filtre({required this.user});

  @override
  State<Filtre> createState() => _FiltreState();
}

class _FiltreState extends State<Filtre> {
  // Déclarations des variables
  User? user;
  String? genre;
  bool? sympathisant = false;
  bool? loading = false;
  final _key = GlobalKey<FormState>();

  @override
  void initState() {
    user = widget.user;
    _getAllNiveau();
    _getAllFilieres();
    _getAllFonctions();
    _getallAxes();
    _getallSections();
    super.initState();
  }

  /** -------------------------- Sections ----------------------------------------- **/
  int selectedSecionsId = 0;
  List<SectionsModel> _sectionsList = [];
  Future _getallSections() async{
    ApiResponse apiResponse = await getAllSections();
    if(apiResponse.error == null){
      List<dynamic> sectionsList = apiResponse.data as List<dynamic>;
      List<SectionsModel> sectionModel = sectionsList.map((p) => SectionsModel.fromJson(p)).toList();
      setState(() {
        _sectionsList = sectionModel;
      });

      if(_sectionsList.isEmpty){
        setState(() {
          selectedSecionsId = 0;
        });
      }else if(!_sectionsList.any((element) => element.id == selectedSecionsId)){
        setState(() {
          selectedSecionsId = _sectionsList.first.id!;
        });
      }

    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  /** -------------------------- Axes ----------------------------------------- **/
  int selectedAxesId = 0;
  List<Axes> _axesList = [];
  Future _getallAxes() async{
    ApiResponse apiResponse = await getAllAxes();
    if(apiResponse.error == null){
      List<dynamic> axesList = apiResponse.data as List<dynamic>;
      List<Axes> axes = axesList.map((p) => Axes.fromJson(p)).toList();
      setState(() {
        _axesList = axes;
      });

      if(_axesList.isEmpty){
        setState(() {
          selectedAxesId = 0;
        });
      }else if(!_axesList.any((element) => element.id == selectedAxesId)){
        setState(() {
          selectedAxesId = _axesList.first.id!;
        });
      }

    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  /** -------------------------- Fonctions ----------------------------------------- **/
  int selectedFonctionsId = 0;
  List<FonctionModel> _listFonctions = [];
  Future _getAllFonctions() async{
    ApiResponse apiResponse = await getAllFonctions();
    if(apiResponse.error == null){
      List<dynamic> fonctionsList = apiResponse.data as List<dynamic>;
      List<FonctionModel> fonctions = fonctionsList.map((p) => FonctionModel.fromJson(p)).toList();
      setState(() {
        _listFonctions = fonctions;
      });

      if(_listFonctions.isEmpty){
        setState(() {
          selectedFonctionsId = 0;
        });
      }else if(!_listFonctions.any((element) => element.id == selectedFonctionsId)){
        setState(() {
          selectedFonctionsId = _listFonctions.first.id!;
        });
      }

    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  /** -------------------------- Filières ----------------------------------------- **/
  int selectedFilieresId = 0;
  List<Filieres> _listFilieres = [];
  Future _getAllFilieres() async{
    ApiResponse apiResponse = await getAllFilieres();
    if(apiResponse.error == null){
      List<dynamic> filieresList = apiResponse.data as List<dynamic>;
      List<Filieres> filieres = filieresList.map((p) => Filieres.fromJson(p)).toList();
      setState(() {
        _listFilieres = filieres;
      });
      if(_listFilieres.isEmpty){
        setState(() {
          selectedFilieresId = 0;
        });
      }else if(!_listFilieres.any((element) => element.id == selectedFilieresId)){
        setState(() {
          selectedFilieresId = _listFilieres.first.id!;
        });
      }
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }

  /** -------------------------- Niveau ----------------------------------------- **/
  int selectedNiveauId = 0;
  List<Niveau> _listNiveau = [];
  Future _getAllNiveau() async{
    ApiResponse apiResponse = await getAllNiveau();
    if(apiResponse.error == null){
      List<dynamic> niveauList = apiResponse.data as List<dynamic>;
      List<Niveau> niveau = niveauList.map((p) => Niveau.fromJson(p)).toList();
      setState(() {
        _listNiveau = niveau;
      });

      if(_listNiveau.isEmpty){
        setState(() {
          selectedNiveauId = 0;
        });
      }else if(!_listNiveau.any((element) => element.id == selectedNiveauId)){
        setState(() {
          selectedNiveauId = _listNiveau.first.id!;
        });
      }

    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        title: Text("Filtre", style: style_google.copyWith(color: Colors.blueGrey, fontWeight: FontWeight.bold),),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.filter_alt_outlined, color: Colors.blueGrey,))
        ],
      ),
      body: Column(
        children: [
            Expanded(
                child: SingleChildScrollView(
                    child: Form(
                      key: _key,
                      child: Card(
                        shape: Border(),
                        child: Column(
                          children: [
                            Padding(
                                padding: EdgeInsets.symmetric(horizontal: 5),
                                child: Column(
                                  children: [
                                    Titre("Fonctions"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.account_tree, color: Colors.grey,),
                                          SizedBox(width: 10,),
                                          DropdownButton(
                                              underline: SizedBox(height: 0,),
                                              hint: Text("Sélectionner votre fonctions                 ", style: style_google.copyWith(color: Colors.grey),),
                                              value: selectedFonctionsId,
                                              items: [
                                                DropdownMenuItem<int>(
                                                    value: 0,
                                                    child: Center(child: Text('Veuillez sélectionner votre fonction', style: style_google,))
                                                ),
                                                ..._listFonctions.map<DropdownMenuItem<int>>((FonctionModel fonction){
                                                  return DropdownMenuItem<int>(
                                                      value: fonction.id,
                                                      child: Center(child: Text(fonction.fonctions!, style: style_google.copyWith(color: Colors.grey),))
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (int? value){
                                                setState(() {
                                                  selectedFonctionsId = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    Ligne(color: Colors.grey),
                                    Titre("Filières"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.local_library_sharp, color: Colors.grey,),
                                          SizedBox(width: 10,),
                                          DropdownButton(
                                              underline: SizedBox(height: 0,),
                                              hint: Text("Sélectionner votre filières                     ", style: style_google.copyWith(color: Colors.grey),),
                                              value: selectedFilieresId,
                                              items: [
                                                DropdownMenuItem<int>(
                                                    value: 0,
                                                    child: Center(child: Text('Veuillez sélectionner votre filière', style: style_google,))
                                                ),
                                                ..._listFilieres.map<DropdownMenuItem<int>>((Filieres filiere){
                                                  return DropdownMenuItem<int>(
                                                      value: filiere.id,
                                                      child: Center(
                                                          child: Text(filiere.nom_filieres!, style: style_google.copyWith(color: Colors.grey),))
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (int? value){
                                                setState(() {
                                                  selectedFilieresId = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    Ligne(color: Colors.grey),
                                    Titre("Niveau"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.stacked_bar_chart, color: Colors.grey,),
                                          SizedBox(width: 10,),
                                          DropdownButton(
                                              underline: SizedBox(height: 0,),
                                              hint: Text("Sélectionner votre niveau                      ", style: style_google.copyWith(color: Colors.grey),),
                                              value: selectedNiveauId,
                                              items: [
                                                DropdownMenuItem<int>(
                                                    value: 0,
                                                    child: Center(child: Text('Veuillez sélectionner votre niveau', style: style_google,))
                                                ),
                                                ..._listNiveau.map<DropdownMenuItem<int>>((Niveau niveau){
                                                  return DropdownMenuItem<int>(
                                                      value: niveau.id,
                                                      child: Center(
                                                          child: Text(niveau.niveau!, style: style_google.copyWith(color: Colors.grey),))
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (int? value){
                                                setState(() {
                                                  selectedNiveauId = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    Ligne(color: Colors.grey),
                                    Titre("Sections"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.dashboard_outlined, color: Colors.grey,),
                                          SizedBox(width: 10,),
                                          DropdownButton(
                                              underline: SizedBox(height: 0,),
                                              hint: Text("Sélectionner votre sections                    "),
                                              value: selectedSecionsId,
                                              items: [
                                                DropdownMenuItem<int>(
                                                    value: 0,
                                                    child: Center(child: Text('Veuillez sélectionner votre section', style: style_google,))
                                                ),
                                                ..._sectionsList.map<DropdownMenuItem<int>>((SectionsModel section){
                                                  return DropdownMenuItem<int>(
                                                      value: section.id,
                                                      child: Center(child: Text(section.nom_sections!, style: style_google.copyWith(color: Colors.grey),))
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (int? value){
                                                setState(() {
                                                  selectedSecionsId = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    Ligne(color: Colors.grey),
                                    Titre("Axes"),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Row(
                                        children: [
                                          Icon(Icons.local_library_sharp, color: Colors.grey,),
                                          SizedBox(width: 10,),
                                          DropdownButton(
                                              underline: SizedBox(height: 0,),
                                              hint: Text("Sélectionner votre axes                           "),
                                              value: selectedAxesId,
                                              items: [
                                                DropdownMenuItem<int>(
                                                    value: 0,
                                                    child: Center(child: Text('Veuillez sélectionner votre axe', style: style_google.copyWith(color: Colors.grey),))
                                                ),
                                                ..._axesList.map<DropdownMenuItem<int>>((Axes axes){
                                                  return DropdownMenuItem<int>(
                                                      value: axes.id,
                                                      child: Center(child: Text(axes.nom_axes!, style: style_google.copyWith(color: Colors.grey),))
                                                  );
                                                }).toList(),
                                              ],
                                              onChanged: (int? value){
                                                setState(() {
                                                  selectedAxesId = value!;
                                                });
                                              }),
                                        ],
                                      ),
                                    ),
                                    Ligne(color: Colors.grey),
                                    Titre("Genre"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 30),
                                      child: Row(
                                        children: [
                                          Radio(
                                              activeColor: Colors.blueGrey,
                                              value: "Masculin", groupValue: genre, onChanged: (dynamic value){
                                            setState(() {
                                              genre = value;
                                            });
                                          }),
                                          Icon(Icons.man, color: Colors.blueGrey,),
                                          Text("Masculin", style: style_google.copyWith(fontSize: 16, color: Colors.grey),),
                                          SizedBox(width: 30,),
                                          Radio(
                                              activeColor: Colors.pink,
                                              value: "Feminin", groupValue: genre, onChanged: (dynamic value){
                                            setState(() {
                                              genre = value;
                                            });
                                          }),
                                          Icon(Icons.woman_2, color: Colors.pink,),
                                          Text("Feminin", style: style_google.copyWith(fontSize: 16, color: Colors.grey)),
                                        ],
                                      ),
                                    ),                                    Ligne(color: Colors.grey),
                                    Titre("Sympathisant"),
                                    Padding(
                                      padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                                      child: Row(
                                        children: [
                                          Text("Uniquement les sympathisants ?              ", style: style_google.copyWith(color: Colors.grey, fontSize: 16),),
                                          SizedBox(width: 10,),
                                          Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.blueGrey
                                              ),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Theme(
                                              data: ThemeData(
                                                  unselectedWidgetColor: Colors.transparent
                                              ),
                                              child: Checkbox(
                                                value: sympathisant,
                                                onChanged: (state){
                                                  setState(() {
                                                    sympathisant = !sympathisant!;
                                                  });
                                                },
                                                activeColor: Colors.transparent,
                                                checkColor: Colors.blueGrey,
                                                materialTapTargetSize: MaterialTapTargetSize.padded,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Ligne(color: Colors.grey),
                                    SizedBox(height: 5,),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () => loading == true ? onLoading(context) :  _validation(),
                                          child: Container(
                                              width: MediaQuery.of(context).size.width - 20,
                                              height: 50,
                                              color: Colors.lightBlue,
                                              child: Center(child: Text("Recherche", style: style_google.copyWith(color: Colors.white, fontSize: 16),))
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15,)
                                  ],
                                ),
                            )
                          ],
                        ),
                      ),
                    ),
            )
          )
        ],
      ),
    );
  }

  Future<void> _validation() async{
      if(_key.currentState!.validate()){
        if(selectedAxesId != 0 && sympathisant == true){
          MessageAvertissement(context, "Avertissement");
        }else{
          setState(() {
            loading = false;
          });
          print("sympathisant : $sympathisant");

          Navigator.push(context, MaterialPageRoute(builder: (ctx) => ResultFiltreMembres(
              fonctionId: selectedFonctionsId,
              filiereId: selectedFilieresId,
              niveauId: selectedNiveauId,
              sectionId: selectedSecionsId,
              axesId: selectedAxesId,
              genre: genre,
              sympathisant: sympathisant,
              user: user)
          ));
        }
      }
  }

  Padding Titre(String titre){
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 0),
      child: Row(
        children: [
          Text(titre, style: style_google.copyWith(fontSize: 17),),
        ],
      ),
    );
  }
}
