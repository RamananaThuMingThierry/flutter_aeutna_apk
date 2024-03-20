import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/screens/auth/register.dart';
import 'package:aeutna/widgets/inputText.dart';
import 'package:flutter/material.dart';

class MotDePasseOublier extends StatefulWidget {
  const MotDePasseOublier({Key? key}) : super(key: key);

  @override
  State<MotDePasseOublier> createState() => _MotDePasseOublierState();
}

class _MotDePasseOublierState extends State<MotDePasseOublier> {
  // Déclarations de mot de passe
  String? email;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: _key,
          child: Column(
            children: [
              SizedBox(height: 100,),
              Container(
                width: 120,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.asset("assets/logo.jpeg"),
                ),
              ),
              SizedBox(height: 100,),
              InputText(hint: "Adresse e-mail", onChanged: () => (value){
                setState(() {
                  email = value;
                });
              }, validator: () => (value){
                if(value == "" || value.isEmpty){
                  return "Veuillez saisir votre adresse e-mail";
                }
              }, iconData: Icons.email_outlined, textInputType: TextInputType.emailAddress),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(child: Text("Nous enverrons les instructions pour réinitialiser votre mot de passe par e-mail", style: style_google.copyWith(color: Colors.grey),),),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () => (){},
                  child: Container(
                    width: double.infinity,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    ),
                    alignment: Alignment.center,
                    child: Text("Enregistre", style: style_google.copyWith(color: Colors.white, fontSize: 15),),
                  ),
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
              Text("N'avez-vous pas de compte ?", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Register();
                  }));
                },
                child: Text("Inscrivez-vous", style: TextStyle(
                  color: Colors.blueGrey,
                ),),
              ),
            ]),
      ),
    );
  }

  void _valider(){
    if(_key.currentState!.validate()){
      print("Reset password");
    }else{
      print("Erreur");
    }
  }
}
