import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/auth/reset_password_forget.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/myTextFieldForm.dart';
import 'package:flutter/material.dart';

class Comfirmation extends StatefulWidget {
  final String token;
  const Comfirmation({Key? key,required this.token}) : super(key: key);

  @override
  State<Comfirmation> createState() => _ComfirmationState();
}

class _ComfirmationState extends State<Comfirmation> {
  // Déclarations de mot de passe
  String? token;
  String? nombre;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  void initState() {
    token = widget.token;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  child: Image.asset("assets/logo.jpeg"),
                ),
              ),
              SizedBox(height: 100,),
              SizedBox(child: Text("Veuillez confirmer par le numéro envoyé dans votre Gmail.", style: style_google,)),
              SizedBox(height: 10,),
              MyTextFieldForm(name: "Numéro", onChanged: () => (value){
                setState(() {
                  nombre = value;
                });
                print(nombre);
              }, validator: () => (value){
                if(value == "" || value.isEmpty){
                  return "Veuillez saisir le numéro de comfirmation";
                }else if(value.length != 6){
                  return "Le numéro est composé de 6 chiffres";
                }
              }, iconData: Icons.confirmation_num_outlined,
                textInputType: TextInputType.number,
                edit: false, value: "",),
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
                  child: Text("Confirmer", style: style_google.copyWith(color: Colors.white, fontSize: 15),),
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
              Text("Retour à la ", style: TextStyle(color: Colors.grey),),
              SizedBox(width: 5,),
              GestureDetector(
                onTap: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext ctx){
                    return Login();
                  }));
                },
                child: Text("connexion", style: TextStyle(
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
      print(nombre);
      ApiResponse apiResponse = await comfirmationEmail(nombre: nombre);
      if(apiResponse.error == null){
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => ReinitialiserMotDePasseOublier(token: token,)), (route) => false);
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
