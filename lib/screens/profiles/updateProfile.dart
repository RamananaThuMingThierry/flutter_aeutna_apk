import 'dart:io';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/splash_screen/splash_screen.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/button.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfile extends StatefulWidget {
  User? user;
  UpdateProfile({required this.user});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  User? user;
  String? pseudo, email, contact,adresse, image;
  String? image_update;
  bool? image_existe;
  File? imageFiles;
  bool? loading = false;
  CroppedFile? croppedImage;
  final _key = GlobalKey<FormState>();
  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');


  @override
  void initState() {
    user = widget.user;
    pseudo = user!.pseudo;
    email = user!.email;
    contact = user!.contact;
    image_update = user!.image;
    adresse = user!.adresse;
    image_existe = user!.image == null ? false : true;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: .5,
        backgroundColor: Colors.white,
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
                          Titre("Pseudo"),
                          MyTextFieldForm(
                              name: "Pseudo",
                              onChanged: () => (value){
                                setState(() {
                                  pseudo = value;
                                });
                              },
                              validator: () => (value){
                                if(value == null || value.isEmpty){
                                  return 'Veuillez entrer votre pseudo!';
                                }
                              }, iconData: Icons.person_2_outlined,
                              textInputType: TextInputType.text,
                              edit: true,
                              value: pseudo!),
                          Titre("Adresse e-mail"),
                          MyTextFieldForm(
                              name: "E-mail",
                              onChanged: () => (value){
                                setState(() {
                                  email = value;
                                });
                              },
                              validator: () => (value){
                                if(value == ""){
                                  return "Veuillez saisir votre adresse email!";
                                }else if(!regExp.hasMatch(value!)){
                                  return "Email invalide!";
                                }
                              }, iconData: Icons.email,
                              textInputType: TextInputType.emailAddress,
                              edit: true,
                              value: email!),
                          Titre("Contact"),
                          MyTextFieldForm(
                              edit: true,
                              value: contact!,
                              name: "Contact",
                              onChanged: () => (value) => {
                                setState(() {
                                  contact = value;
                                })
                              },
                              validator: () => (value){
                                if(value == ""){
                                  return "Veuillez saisir votre contact!";
                                }else if(value!.length != 10){
                                  return "Votre numéro doit-être composé de 10 chiffres!";
                                }else if(!verifierPrefixNumeroTelephone(value)){
                                  return "Votre numéro n'est pas valide!";
                                }
                              },
                              iconData: Icons.phone,
                              textInputType: TextInputType.phone),
                          Titre("Adresse"),
                          MyTextFieldForm(
                              edit: true,
                              value: adresse!,
                              name: "Adresse",
                              onChanged: () => (value) => {
                                setState(() {
                                  adresse = value;
                                })
                              },
                              validator: () => (value){
                                if(value == ""){
                                  return "Veuillez saisir votre adresse!";
                                }
                              },
                              iconData: Icons.location_on_outlined,
                              textInputType: TextInputType.text),
                              SizedBox(height: 20,),
                              SizedBox(
                                width: double.infinity,
                                child: TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                                  ),
                                  onPressed: () {
                                    _validation();
                                  },
                                  child: Text("Modifier", style: style_google.copyWith(color: Colors.white),),
                                )
                              ),
                              SizedBox(height: 20,)
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

  Future<void> _validation() async {
    if(_key.currentState!.validate()){
      String? _images;
      if(image_existe == false){
        MessageAvertissement(context, "Veuillez sélectionner votre photo!");
      }else{
        if(image == null){
          _images = image_update!;
        }else{
          _images = imageFiles == null ? null : getStringImage(imageFiles);
        }

        ApiResponse apiResponse = await updateUser(
            image: _images,
            userId: user!.id,
            pseudo: pseudo,
            email: email,
            contact: contact,
            adresse: adresse
        );

        if(apiResponse.error == null){
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => SplashScreen()), (route) => false);
        }else if(apiResponse.error == avertissement){
          MessageAvertissement(context, "${apiResponse.data}");
        }else if(apiResponse.error == unauthorized){
          MessageErreurs(context, apiResponse.error);
        }else{
          MessageErreurs(context, "${apiResponse.error}");
        }
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
