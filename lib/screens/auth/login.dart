import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/register.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/PasswordFiledForm.dart';
import 'package:aeutna/widgets/button.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  // Déclarations des variables
  bool visibility = true;
  bool loading  = false;
  String? email;
  String? mot_de_passe;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');


  void _saveAndRedirectToHome(User user) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setString('token', user.token ?? '');
    await sharedPreferences.setInt('userId', user.id ?? 0);
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil()), (route) => false);
  }

  void loginUser() async{
    if(_key.currentState!.validate()){

      ApiResponse apiResponse = await login(email: email!,mot_de_passe: mot_de_passe!);

      print(apiResponse.error);

      if(apiResponse.error == null){
        _saveAndRedirectToHome(apiResponse.data as User);
      }else{
        setState(() {
          loading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${apiResponse.error}')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Form(
          key: _key,
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25), // Image border
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(50), // Image radius
                            child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text("Connexion", style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xffE2C222),
                      ),),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          height: 2,
                          width: 90,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 170,
                  margin: EdgeInsets.symmetric(horizontal: 10 ),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Email
                      MyTextFieldForm(
                          edit: false,
                          value: "",
                          name: "Email",
                          onChanged: () => (value) => setState(() {
                            email = value;
                          }),
                          validator:() =>  (value){
                            if(value == ""){
                              return "Veuilez saisir votre adresse email";
                            }else if(!regExp.hasMatch(value!)){
                              return "Votre adresse email est invalide!";
                            }
                          },
                          iconData: Icons.mail,
                          textInputType: TextInputType.emailAddress,
                          ),
                      // Password
                      PasswordFieldForm(
                          visibility: visibility,
                          validator: () => (value){
                            if(value == ""){
                              return "Veuillez saisir votre mot de passe";
                            }else if(value!.length < 6){
                              return "Votre mot de passe doit avoir au moins 8 caractères";
                            }
                          },
                          name: "Mot de passe",
                          onTap: () => (){
                            FocusScope.of(context).unfocus();
                            setState(() {
                              visibility = !visibility;
                            });
                            print("${visibility}");
                          },
                          onChanged: () => (value) => setState(() {
                            mot_de_passe = value;
                          }),
                      )
                    ],
                  ),
                ),
                Padding(padding: EdgeInsets.symmetric(horizontal: 20),
                  child:  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("Mot de passe oublie!", style: TextStyle(color: Colors.blueAccent),),
                    ],
                  ),),
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: double.infinity,
                    child: Button(
                      color: Colors.blueGrey,
                      name: "Login",
                      onPressed: () => loginUser,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Je n'ai pas de compte!", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Register();
                  }));
                },
                child: Text("s'inscrire", style: TextStyle(
                  color: Color(0xffE2C222),
                  fontWeight: FontWeight.bold,
                ),),
              ),
            ]),
      ),
    );
  }
}
