import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/PasswordFiledForm.dart';
import 'package:aeutna/widgets/inputText.dart';
import 'package:flutter/material.dart';

class ModifierMotDePasse extends StatefulWidget {
  const ModifierMotDePasse({Key? key}) : super(key: key);

  @override
  State<ModifierMotDePasse> createState() => _ModifierMotDePasseState();
}

class _ModifierMotDePasseState extends State<ModifierMotDePasse> {
  // Déclarations de mot de passe
  bool visibility_ancien_password = false;
  bool visibility_nouveau_password = false;
  bool visibility_confirmer_password = false;

  String? ancien_mot_de_passe, nouveau_mot_de_de_passe, comfirmer_mot_de_passe;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        centerTitle: true,
        title:Text("Changer votre mot de passe", style: style_google.copyWith(fontSize: 17, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit, color: Colors.blueGrey,)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          child: Form(
            key: _key,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                PasswordFieldForm(visibility: visibility_ancien_password, validator: () => (value){
                  if(value == "" || value.isEmpty){
                    return "Veuillez saisir votre ancien mot de passe";
                  }
                }, name: "Ancien mot de passe",
                onTap: () => (){
                  setState(() {
                    visibility_ancien_password = !visibility_ancien_password;
                  });
                }, onChanged: () => (value){
                  setState(() {
                    ancien_mot_de_passe = value;
                  });
                }),
                SizedBox(height: 10,),
                PasswordFieldForm(
                    visibility: visibility_nouveau_password,
                    validator: () => (value){
                      if(value == "" || value.isEmpty){
                        return "Veuillez saisir votre nouveau mot de passe";
                      }
                    },
                    name: "Nouveau mot de passe",
                    onTap: () => (){
                      setState(() {
                        visibility_nouveau_password = !visibility_nouveau_password;
                      });
                    },
                    onChanged: () => (value){
                      setState(() {
                        nouveau_mot_de_de_passe = value;
                      });
                    }
                ),
                SizedBox(height: 10,),
                PasswordFieldForm(
                    visibility: visibility_confirmer_password,
                    validator: () => (value){
                      if(value == "" || value.isEmpty){
                        return "Veuillez confirmer votre nouveau mot de passe";
                      }else if(value != nouveau_mot_de_de_passe){
                        return "Votre mot de passe ne correspond pas";
                      }
                    },
                    name: "Confirmer votre mot de passe",
                    onTap: () => (){
                      setState(() {
                        visibility_confirmer_password = !visibility_confirmer_password;
                      });
                    },
                    onChanged: () => (value){
                      setState(() {
                        comfirmer_mot_de_passe = value;
                      });
                    }
                ),
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
                    child: Text("Enregistre", style: style_google.copyWith(color: Colors.white, fontSize: 15),),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _valider() async {
    if(_key.currentState!.validate()){
      onLoading(context);
      ApiResponse apiResponse = await updatePasswordUser(password_old: ancien_mot_de_passe, password_new: nouveau_mot_de_de_passe);
      if(apiResponse.error == null){
        Navigator.pop(context);
        onLoadingDeconnection(context);
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
