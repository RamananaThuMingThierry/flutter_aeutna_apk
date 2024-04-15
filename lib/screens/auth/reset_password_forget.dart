import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/PasswordFiledForm.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';

class ReinitialiserMotDePasseOublier extends StatefulWidget {
  final String? token;
  const ReinitialiserMotDePasseOublier({Key? key, required this.token}) : super(key: key);

  @override
  State<ReinitialiserMotDePasseOublier> createState() => _ReinitialiserMotDePasseOublierState();
}

class _ReinitialiserMotDePasseOublierState extends State<ReinitialiserMotDePasseOublier> {
  // Déclarations de mot de passe
  bool visibilite = true;
  String? token;
  bool visibilite_confirmation = true;
  String? email;
  String? mot_de_passe;
  String? mot_de_passe_comfirmation;

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    token = widget.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _key,
          child: Column(
            children: [
              SizedBox(height: 100,),
              Container(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/logo.jpg"),
                ),
              ),
              SizedBox(child: Text("A.E.U.T.N.A",style: style_google.copyWith(fontSize: 30,fontWeight: FontWeight.bold),),),
              SizedBox(height: 100,),
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
              SizedBox(height: 10,),
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
              SizedBox(height: 10,),
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
                      mot_de_passe_comfirmation = value;
                    })
                  }),
              SizedBox(height: 10,),
              InkWell(
                onTap: (){
                  _valider();
                },
                child: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                  ),
                  alignment: Alignment.center,
                  child: Text("Réinitialiser", style: style_google.copyWith(color: Colors.white, fontSize: 15),),
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Retour à la ", style: style_google.copyWith(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Login();
                  }));
                },
                child: Text("connexion", style: style_google.copyWith(
                  color:  Color(0xffE2C222),
                ),),
              ),
            ]),
      ),
    );
  }

  Future<void> _valider() async {
    if(_key.currentState!.validate()){
      onLoading(context);
      ApiResponse apiResponse = await ReinitialiserMotDePasse(email: email , mot_de_passe: mot_de_passe, token: token);
      if(apiResponse.error == null){
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
        MessageReussi(context, "Votre mot de passe a été bien réinitialiser!");
      }else if(apiResponse.error == avertissement){
        Navigator.pop(context);
        MessageAvertissement(context, "${apiResponse.data}");
      }else{
        Navigator.pop(context);
        MessageErreurs(context, "${apiResponse.error}");
      }
    }
  }
}
