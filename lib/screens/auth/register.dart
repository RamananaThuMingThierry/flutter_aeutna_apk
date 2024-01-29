import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/PasswordFiledForm.dart';
import 'package:aeutna/widgets/button.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  // Déclarations des variables
  bool visibilite = true;
  bool visibilite_confirmation = true;
  String? pseudo;
  String? email;
  String? adresse;
  String? contact;
  String? mot_de_passe;
  String? mot_de_passe_confirmation;

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  void _registerUser() async{
    if(_key.currentState!.validate()){
      ApiResponse apiResponse = await register(pseudo: pseudo, email: email, adresse: adresse, contact: contact, mot_de_passe: mot_de_passe);
      if(apiResponse.error == null){
        _saveAndRedirectToHome(apiResponse.data as User);
      }else if(apiResponse.error == avertissement){
        MessageAvertissement(context, "${apiResponse.data}");
      }else{
        MessageErreurs(context, "${apiResponse.error}");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
      }
    }
  }

void _saveAndRedirectToHome(User user) async{
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  sharedPreferences.setString('token', user.token ?? '');
  sharedPreferences.setInt('userId', user.id ?? 0);
  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil()), (route) => false);
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child:Form(
            key: _key,
            child: Container(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          width: 100,
                          height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50), // Image border
                            child: SizedBox.fromSize(
                              size: Size.fromRadius(50), // Image radius
                              child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "Inscription",
                          style: TextStyle(
                              fontSize: 50,
                              color:Color(0xffE2C222),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            height: 2,
                            width: 100,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  Container(
                    height: 425,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Nom
                        MyTextFieldForm(
                            name: "Pseudo",
                            edit: false,
                            value: "",
                            onChanged: () => (value) => {
                              setState(() {
                                pseudo = value;
                              })
                            },
                            validator:() => (value){
                              if(value == ""){
                                return "Veuillez saisir votre nom!";
                              }
                            },
                            iconData: Icons.account_box,
                            textInputType: TextInputType.name),
                        // Email
                        MyTextFieldForm(
                            edit: false,
                            value: "",
                            name: "Adresse Email",
                            onChanged: () => (value) => {
                              setState(() {
                                email = value;
                              })
                            },
                            validator: () => (value){
                              if(value == ""){
                                return "Veuillez saisir votre adresse email!";
                              }else if(!regExp.hasMatch(value!)){
                                return "Email invalide!";
                              }
                            },
                            iconData: Icons.email,
                            textInputType: TextInputType.emailAddress),
                        // Contact
                        MyTextFieldForm(
                            edit: false,
                            value: "",
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
                        // Adresse
                        MyTextFieldForm(
                            edit: false,
                            value: "",
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
                        // Mot de passe
                        PasswordFieldForm(
                            visibility: visibilite,
                            validator: () => (value){
                              if(value == ""){
                                return "Veuillez saisir votre mot de passe!";
                              }else if(value!.length < 6){
                                return "Le mot de passe doit avoir au moins 8 caractères!";
                              }
                            },
                            name: "Mot de passe",
                            onTap: () => (){
                              setState(() {
                                visibilite = !visibilite;
                              });
                              print("${visibilite}");
                            },
                            onChanged: () => (value) => {
                              setState(() {
                                mot_de_passe = value;
                              })
                            }),
                        // Confrimer votre mot de passe
                        PasswordFieldForm(
                            visibility: visibilite_confirmation,
                            validator: () => (value){
                              if(value == ""){
                                return "Veuillez saisir votre mot de passe!";
                              }else if(value! != mot_de_passe){
                                return "Les deux mot de passe ne correspond pas!";
                              }
                            },
                            name: "Confirmation du mot de passe",
                            onTap: () => (){
                              setState(() {
                                visibilite_confirmation = !visibilite_confirmation;
                              });
                              print("${visibilite_confirmation}");
                            },
                            onChanged: () => (value) => {
                              setState(() {
                                mot_de_passe_confirmation = value;
                              })
                            }),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  //Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: double.infinity,
                      child: Button(
                          color: Colors.blueGrey,
                          onPressed: () => _registerUser,
                          name: "S'inscrire"),
                    ),
                  )
                ],
              ),
            ),
          )
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("J'ai déjà un compte!", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Login();
                  }));
                },
                child: Text("se connecte", style: TextStyle(
                  color: Color(0xffE2C222),
                  fontWeight: FontWeight.bold,
                ),),
              )
            ]),
      ),
    );
  }
}
