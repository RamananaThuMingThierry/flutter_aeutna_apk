import 'dart:io';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/axes.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/models/sections.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/membres/membres.dart';
import 'package:aeutna/services/axes_services.dart';
import 'package:aeutna/services/filieres_services.dart';
import 'package:aeutna/services/fonctions_services.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/services/niveau_services.dart';
import 'package:aeutna/services/sections_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ModifierMembres extends StatefulWidget {
  Membres? membres;
  User? user;
  ModifierMembres({required this.membres, required this.user});

  @override
  State<ModifierMembres> createState() => _ModifierMembresState();
}

class _ModifierMembresState extends State<ModifierMembres> {
  // Déclarations des variables
  Membres? membres;
  User? user;
  int? numero_carte, axes_id, filieres_id, levels_id, fonctions_id, sections_id;
  String? image, nom, prenom, contact,genre, date_de_naissance, lieu_de_naissance,etablissement, cin, contact_personnel, contact_tuteur, facebook, adresse, date_inscription;
  String? image_update;
  bool? image_existe;
  bool? sympathisant;
  File? imageFiles;
  bool? loading = false;
  CroppedFile? croppedImage;
  final _key = GlobalKey<FormState>();

  /** -------------------------- Axes ----------------------------------------- **/
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
      }else{
        selectedSecionsId = int.parse(membres!.sections_id!);
      }

    }else if(apiResponse.error == unauthorized){
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
      }else{
        setState(() {
          selectedAxesId = int.parse(membres!.axes_id!);
        });
      }

    }else if(apiResponse.error == unauthorized){
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
      }else{
        setState(() {
          selectedFonctionsId = int.parse(membres!.fonctions_id!);
        });
      }

    }else if(apiResponse.error == unauthorized){
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
      }else{
        setState(() {
          selectedFilieresId = int.parse(membres!.filieres_id!);
        });
      }
    }else if(apiResponse.error == unauthorized){
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
      }else{
        setState(() {
          selectedNiveauId = int.parse(membres!.levels_id!);
        });
      }

    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }


  DateTime? selectedDateDeNaissance = DateTime.now();
  DateTime? selectedDateDInscription = DateTime.now();

  @override
  void initState() {
    membres = widget.membres;
    user = widget.user;
    _getallAxes();
    _getAllFonctions();
    _getAllFilieres();
    _getAllNiveau();
    _getallSections();
    numero_carte = int.parse( membres!.numero_carte!);
    nom = membres!.nom;
    prenom = membres!.prenom ?? '';
    lieu_de_naissance = membres!.lieu_de_naissance;
    adresse = membres!.adresse;
    facebook  = membres!.facebook ?? '';
    genre = membres!.genre;
    cin = membres!.cin == "null" ? '' : membres!.cin;
    etablissement = membres!.etablissement == null ? '' : membres!.etablissement;
    contact_personnel = membres!.contact_personnel;
    contact_tuteur = membres!.contact_tuteur;
    sympathisant = membres!.symapthisant == "0" ? false : true;
    image_update = membres!.image;
    image_existe = membres!.image == null ? false : true;
    setState(() {
      selectedDateDeNaissance = DateTime.parse("${membres!.date_de_naissance}");
      selectedDateDInscription = DateTime.parse("${membres!.date_inscription}");
      date_de_naissance = formatageDate(selectedDateDeNaissance!);
      date_inscription = formatageDate(selectedDateDInscription!);
    });
    super.initState();
  }

  String formatageDate(DateTime date){
    DateTime dateformat = DateTime(date!.year, date!.month, date!.day);
    return DateFormat('yyyy-MM-dd').format(dateformat);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        title: TitreText("Modification"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){},
              icon: Icon(Icons.update, color: Colors.blueGrey,)
          )
        ],
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        backgroundColor: Colors.white,
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
                        (image_existe == false)
                            ?  Image.asset("assets/no_image.jpg")
                            : (image_update != null)
                                  ? Image.network(image_update!, fit: BoxFit.cover,)
                                  : (croppedImage != null) ? Image.file(File(croppedImage!.path)) : Image.asset("assets/no_image.jpg"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                                onPressed: () => getImage(ImageSource.camera),
                                icon: Icon(Icons.camera_alt_outlined, color: Colors.black,)
                            ),
                            IconButton(
                                onPressed: () => getImage(ImageSource.gallery),
                                icon: Icon(Icons.photo_library_outlined, color: Colors.greenAccent,)
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              Divider(
                                color: Colors.grey,
                                thickness: 1,
                              ),
                              Titre("Numéro Carte"),
                              MyTextFieldForm(
                                  name: "Numéro carte",
                                  onChanged: () => (value){
                                    setState(() {
                                      numero_carte = int.parse(value);
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer le numéro de votre carte.';
                                    }
                                    try{
                                      int nombre = int.parse(value);
                                      if(nombre < 0){
                                        return 'Veuillez entrer un nombre entier positif.';
                                      }
                                    }catch(e){
                                      return 'Veuillez entrer un nombre entier positif.';
                                    }
                                  }, iconData: Icons.confirmation_num_outlined,
                                  textInputType: TextInputType.number,
                                  edit: true,
                                  value: numero_carte.toString()),
                              Titre("Nom"),
                              MyTextFieldForm(
                                  name: "Nom",
                                  onChanged: () => (value){
                                    setState(() {
                                      nom = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer votre nom!';
                                    }
                                  }, iconData: Icons.person_2_outlined,
                                  textInputType: TextInputType.text,
                                  edit: true,
                                  value: nom!),
                              Titre("Prénom"),
                              MyTextFieldForm(
                                  name: "Prénom",
                                  onChanged: () => (value){
                                    setState(() {
                                      prenom = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value.isEmpty || value == null) return null;
                                  }, iconData: Icons.person_2_outlined,
                                  textInputType: TextInputType.text,
                                  edit: true,
                                  value: prenom!),
                              Titre("Date de naissance"),
                              Row(
                                children: [
                                  IconButton(onPressed: (){
                                    _selectedDateDeNaissance(context);
                                  } , icon: Icon(Icons.calendar_month, color: Colors.grey,)),
                                  Text("${DateFormat.yMMMMd('fr').format(selectedDateDeNaissance!)}", style: style_google.copyWith(color: Colors.grey),)
                                ],
                              ),
                              Ligne(color: Colors.grey),
                              Titre("Lieu de naissance"),
                              MyTextFieldForm(
                                  name: "Lieu de naissance",
                                  onChanged: () => (value){
                                    setState(() {
                                      lieu_de_naissance = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer votre lieu de naissance!';
                                    }
                                  }, iconData: Icons.add_location,
                                  textInputType: TextInputType.text,
                                  edit: true,
                                  value: lieu_de_naissance!),
                              Titre("C.I.N"),
                              MyTextFieldForm(
                                  name: "C.I.N",
                                  onChanged: () => (value){
                                    setState(() {
                                      cin = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return null;
                                    }else if(value.length != 12){
                                      return 'C.I.N doit-être composer de 12 chiffres!';
                                    }
                                  }, iconData: Icons.call_to_action,
                                  textInputType: TextInputType.number,
                                  edit: true,
                                  value: cin ?? ''),
                              Titre("Genre"),
                              Padding(
                                padding: EdgeInsets.only(left: 30),
                                child: Row(
                                  children: [
                                    Radio(
                                        activeColor: Colors.blueGrey,
                                        value: "Masculin",
                                        groupValue: genre, onChanged: (dynamic value){
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
                              ),
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
                                              child: Center(child: Text('Aucun', style: style_google.copyWith(color: Colors.grey),))
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
                                              child: Center(child: Text('Aucun', style: style_google.copyWith(color: Colors.grey),))
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
                              /** ============================= Etablissement ================================== **/
                              Titre("Etablissement"),
                              MyTextFieldForm(
                                  name: "Etablissement",
                                  onChanged: () => (value){
                                    setState(() {
                                      etablissement = value;
                                    });
                                  },
                                  validator: () => (value){
                                  }, iconData: Icons.school_outlined,
                                  textInputType: TextInputType.text,
                                  edit: true,
                                  value: etablissement!),
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
                                              child: Center(child: Text('Aucun', style: style_google.copyWith(color: Colors.grey),))
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
                              Titre("Adresse"),
                              MyTextFieldForm(
                                  name: "Adresse",
                                  onChanged: () => (value){
                                    setState(() {
                                      adresse = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer votre adresse';
                                    }
                                  }, iconData: Icons.add_location,
                                  textInputType: TextInputType.text,
                                  edit: true,
                                  value: adresse!),
                              Titre("Sections"),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Row(
                                  children: [
                                    Icon(Icons.dashboard_outlined, color: Colors.grey,),
                                    SizedBox(width: 10,),
                                    DropdownButton(
                                        underline: SizedBox(height: 0,),
                                        hint: Text("Sélectionner votre section                     "),
                                        value: selectedSecionsId,
                                        items: [
                                          DropdownMenuItem<int>(
                                              value: 0,
                                              child: Center(child: Text('Veuillez sélectionner votre section', style: style_google.copyWith(color: Colors.grey),))
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
                              Titre("Contact Personnel"),
                              MyTextFieldForm(
                                  name: "Contact Personnel",
                                  onChanged: () => (value){
                                    setState(() {
                                      contact_personnel = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer votre contact personnel';
                                    }else if(value!.length != 10){
                                      return "Votre numéro doit-être composé de 10 chiffres!";
                                    }else if(!verifierPrefixNumeroTelephone(value)){
                                      return "Votre numéro n'est pas valide!";
                                    }
                                  }, iconData: Icons.call_outlined,
                                  textInputType: TextInputType.number,
                                  edit: true,
                                  value: contact_personnel!),
                              Titre("Contact Tuteur"),
                              MyTextFieldForm(
                                  name: "Contact Tuteur",
                                  onChanged: () => (value){
                                    setState(() {
                                      contact_tuteur = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer votre contact parental';
                                    }else if(value!.length != 10){
                                      return "Votre numéro doit-être composé de 10 chiffres!";
                                    }else if(!verifierPrefixNumeroTelephone(value)){
                                      return "Votre numéro n'est pas valide!";
                                    }
                                  }, iconData: Icons.call_outlined,
                                  textInputType: TextInputType.number,
                                  edit: true,
                                  value: contact_tuteur!),
                              Titre("Facebook"),
                              MyTextFieldForm(
                                  name: "Facebook",
                                  onChanged: () => (value){
                                    setState(() {
                                      facebook = value;
                                    });
                                  },
                                  validator: () => (value){
                                    if(value == null || value.isEmpty){
                                      return 'Veuillez entrer votre facebook';
                                    }
                                  }, iconData: Icons.facebook_rounded,
                                  textInputType: TextInputType.text,
                                  edit: true,
                                  value: facebook!),
                              Titre("Sympathisant"),
                              Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
                                child: Row(
                                  children: [
                                    Text("Est-vous symapthisant ? coucher si oui", style: style_google.copyWith(color: Colors.grey, fontSize: 16),),
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
                              Titre("Date d'inscription"),
                              Row(
                                children: [
                                  IconButton(onPressed: (){
                                    _selectedDateDInscription(context);
                                  } , icon: Icon(Icons.calendar_month, color: Colors.grey,)),
                                  Text("${DateFormat.yMMMMd('fr').format(selectedDateDInscription!)}", style: style_google.copyWith(color: Colors.grey),)
                                ],
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
                                        child: Center(child: Text("Enregistrer", style: style_google.copyWith(color: Colors.white, fontSize: 16),))
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 15,)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  Future<void> _validation() async {
    if(_key.currentState!.validate()){
      if(genre == null){
        MessageAvertissement(context, "Veuillez sélectionner votre genre");
      }else if(selectedFilieresId == 0 && selectedNiveauId != 0){
        MessageAvertissement(context, "Veuillez sélectionner votre filière");
      }else if(selectedFilieresId != 0 && selectedNiveauId == 0){
        MessageAvertissement(context, "Veuillez sélectionner votre niveau");
      }else if(date_de_naissance == null){
        MessageAvertissement(context, "Veuillez sélectionner votre date de naissance");
      }else if(date_inscription == null){
        MessageAvertissement(context, "Veuillez sélectionner votre date d'inscription");
      }else if(sympathisant == true && selectedAxesId != 0){
        MessageAvertissement(context, "Etes-vous vraiment sympathisant ?");
      }else if(sympathisant == false && selectedAxesId == 0){
        MessageAvertissement(context, "Etes-vous sympathisant(e) ?");
      }else{
        String? _images;
        if(image == null){
          _images = image_update!;
        }else{
          _images = imageFiles == null ? null : getStringImage(imageFiles);
        }
        onLoading(context);
        ApiResponse apiResponse = await updateMembre(
            membreIdUpdate: membres!.id,
            image: _images,
            numero_carte: numero_carte,
            nom: nom,
            prenom: prenom,
            date_de_naissance: date_de_naissance,
            lieu_de_naissance: lieu_de_naissance,
            cin: cin == '' ? null : cin,
            genre: genre,
            etablissement: etablissement,
            fonctions_id: selectedFonctionsId,
            filieres_id: selectedFilieresId,
            sectionsId: selectedSecionsId,
            niveau_id: selectedNiveauId,
            axesId: selectedAxesId,
            adresse: adresse,
            contact_personnel: contact_personnel,
            contact_tuteur: contact_tuteur,
            facebook: facebook,
            sympathisant: sympathisant,
            date_inscription: date_inscription
        );

        if(apiResponse.error == null){
          Navigator.pop(context);
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => MembresScreen(user: user!)), (route) => false);
          MessageReussi(context, "${apiResponse.data}");
        }else if(apiResponse.error == avertissement){
          Navigator.pop(context);
          MessageAvertissement(context, "${apiResponse.data}");
        }else if(apiResponse.error == unauthorized){
          Navigator.pop(context);
          MessageErreurs(context, apiResponse.error);
        }else{
          Navigator.pop(context);
          MessageErreurs(context, "${apiResponse.error}");
        }
      }
    }else{
      print("Non");
    }
  }

  Future<void> _selectedDateDInscription(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        helpText: "Selectionner la data d'ajout",
        initialDate: selectedDateDInscription!,
        firstDate: DateTime(2020, 8),
        lastDate: DateTime(2101),
        cancelText: "Annuler",
        confirmText: "Valider",
        fieldLabelText: "Date",
        fieldHintText: "Mois/jour/année",
        errorFormatText: "Entrer la date valide",
        errorInvalidText: "Enter date in valid range",
        builder: (BuildContext context, Widget? child){
          return Theme(data: ThemeData.light(), child: child!);
        }
    );

    if(picked != null && picked != selectedDateDInscription){
      setState(() {
        selectedDateDInscription = picked;
        DateTime date = DateTime(selectedDateDInscription!.year, selectedDateDInscription!.month, selectedDateDInscription!.day);
        date_inscription = DateFormat('yyyy-MM-dd').format(date);
      });
    }
  }

  Future<void> _selectedDateDeNaissance(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        helpText: "Selectionner la data d'ajout",
        initialDate: selectedDateDeNaissance!,
        firstDate: DateTime(1990, 1),
        lastDate: DateTime(2101),
        cancelText: "Annuler",
        confirmText: "Valider",
        fieldLabelText: "Date",
        fieldHintText: "Mois/jour/année",
        errorFormatText: "Entrer la date valide",
        errorInvalidText: "Enter date in valid range",
        builder: (BuildContext context, Widget? child){
          return Theme(data: ThemeData.light(), child: child!);
        }
    );

    if(picked != null && picked != selectedDateDeNaissance){
      setState(() {
        selectedDateDeNaissance = picked;
        DateTime date = DateTime(selectedDateDeNaissance!.year, selectedDateDeNaissance!.month, selectedDateDeNaissance!.day);
        date_de_naissance = DateFormat('yyyy-MM-dd').format(date);
      });
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

  Future getImage(ImageSource source) async{
    final newImage = await ImagePicker().pickImage(source: source);
    if(newImage != null){
      final File image = File(newImage!.path);
      cropImage(image); // Call the image cropping function
    }
  }

  Future cropImage(File imageR) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageR.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Recadrez l\'image',
            toolbarColor: Colors.blueGrey,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.blueGrey,
            hideBottomControls: false,
            cropGridColumnCount: 3,
            cropGridRowCount: 3,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true),
        IOSUiSettings(
          title: 'Cropper',
        ),
        WebUiSettings(
          context: context,
        ),
      ],
    );
    if (croppedFile != null) {
      setState(() {
        croppedImage = croppedFile;
        image = croppedFile.path;
        imageFiles = File(croppedFile!.path);
        image_existe = true;
        image_update = null;
      });
    }
  }
}

