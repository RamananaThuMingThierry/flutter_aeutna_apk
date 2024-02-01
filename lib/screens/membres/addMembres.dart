import 'dart:io';

import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddMembresScreen extends StatefulWidget {
  const AddMembresScreen({Key? key}) : super(key: key);

  @override
  State<AddMembresScreen> createState() => _AddMembresScreenState();
}

class _AddMembresScreenState extends State<AddMembresScreen> {
  // Déclarations des variables
  DateTime? selectedDate = DateTime.now();
  int? numero_porte, axes_id, filieres_id, levels_id, fonctions_id;
  String? image, nom, prenom, contact, date_de_naissance, lieu_de_naissance, cin, contact_personnel, contact_tuteur, facebook, adresse, date_inscription;
  File? imageFiles;
  CroppedFile? croppedImage;
  final _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .5,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
            shape: Border(),
            elevation: .5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Text("Informations", style: style_google,),
                ),
              ],
            ),
          ),
          Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Card(
                    shape: Border(),
                    child: Column(
                      children: [
                        (croppedImage != null) ? Image.file(File(croppedImage!.path)) : Image.asset("assets/no_image.jpg"),
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
                                        numero_porte = int.parse(value);
                                      });
                                      },
                                    validator: () => (value){
                                      if(value == null || value.isEmpty){
                                        return 'Veuillez entrer le nombre de votre carte.';
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
                                    edit: false,
                                    value: ""),
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
                                    edit: false,
                                    value: ""),
                                Titre("Prénom"),
                                MyTextFieldForm(
                                    name: "Prénom",
                                    onChanged: () => (value){
                                      setState(() {
                                        prenom = value;
                                      });
                                    },
                                    validator: () => (value){
                                      if(value == null || value.isEmpty){
                                        return 'Veuillez entrer votre prénom!';
                                      }
                                    }, iconData: Icons.person_2_outlined,
                                    textInputType: TextInputType.text,
                                    edit: false,
                                    value: ""),
                                Titre("Date de naissance"),
                                Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      _selectedDate(context);
                                      setState(() {
                                        date_de_naissance = selectedDate as String?;
                                      });
                                    } , icon: Icon(Icons.calendar_month, color: Colors.grey,)),
                                    Text("${DateFormat.yMMMMd('fr').format(selectedDate!)}", style: style_google.copyWith(color: Colors.grey),)
                                  ],
                                ),
                                Ligne(color: Colors.grey),
                                Titre("Axes"),
                                Row(
                                  children: [

                                  ],
                                ),
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
                                    edit: false,
                                    value: ""),
                                Titre("Facebook"),
                                MyTextFieldForm(
                                    name: "C.I.N",
                                    onChanged: () => (value){
                                      setState(() {
                                        lieu_de_naissance = value;
                                      });
                                    },
                                    validator: () => (value){
                                      if(value == null || value.isEmpty){
                                        return 'Veuillez entrer votre C.I.N!';
                                      }else if(value.length != 12){
                                        return 'C.I.N doit-être composer de 12 chiffres!';
                                      }
                                    }, iconData: Icons.call_to_action,
                                    textInputType: TextInputType.number,
                                    edit: false,
                                    value: ""),
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
                                    }, iconData: Icons.local_library_sharp,
                                    textInputType: TextInputType.text,
                                    edit: false,
                                    value: ""),
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
                                        return 'Veuillez entrer votre contact';
                                      }else if(value!.length != 10){
                                        return "Votre numéro doit-être composé de 10 chiffres!";
                                      }else if(!verifierPrefixNumeroTelephone(value)){
                                        return "Votre numéro n'est pas valide!";
                                      }
                                    }, iconData: Icons.call_outlined,
                                    textInputType: TextInputType.number,
                                    edit: false,
                                    value: ""),
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
                                        return 'Veuillez entrer votre contact';
                                      }else if(value!.length != 10){
                                        return "Votre numéro doit-être composé de 10 chiffres!";
                                      }else if(!verifierPrefixNumeroTelephone(value)){
                                        return "Votre numéro n'est pas valide!";
                                      }
                                    }, iconData: Icons.call_outlined,
                                    textInputType: TextInputType.number,
                                    edit: false,
                                    value: ""),
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
                                    edit: false,
                                    value: ""),
                                Titre("Date d'inscription"),
                                Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      _selectedDate(context);
                                      setState(() {
                                        date_inscription = selectedDate as String?;
                                      });
                                    } , icon: Icon(Icons.calendar_month, color: Colors.grey,)),
                                    Text("${DateFormat.yMMMMd('fr').format(selectedDate!)}", style: style_google.copyWith(color: Colors.grey),)
                                  ],
                                ),
                                Ligne(color: Colors.grey),
                                SizedBox(height: 5,),
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

  Future<void> _selectedDate(BuildContext context) async{
    final DateTime? picked = await showDatePicker(
        context: context,
        helpText: "Selectionner la data d'ajout",
        initialDate: selectedDate!,
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

    if(picked != null && picked != selectedDate){
      setState(() {
        selectedDate = picked;
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
            toolbarColor: Colors.green,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: Colors.green,
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
      print("******************************************************************************** ${croppedFile}");
      setState(() {
        croppedImage = croppedFile;
        image = croppedFile.path;
        imageFiles = File(croppedFile!.path);
      });
      print("******************************************************************************** ${croppedImage}");
    }
  }
}


