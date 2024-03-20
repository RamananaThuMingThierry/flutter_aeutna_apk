import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/widgets/inputText.dart';
import 'package:flutter/material.dart';

class ModifierMotDePasse extends StatefulWidget {
  const ModifierMotDePasse({Key? key}) : super(key: key);

  @override
  State<ModifierMotDePasse> createState() => _ModifierMotDePasseState();
}

class _ModifierMotDePasseState extends State<ModifierMotDePasse> {
  // Déclarations de mot de passe
  String? ancien_mot_de_passe, nouveau_mot_de_de_passe, comfirmer_mot_de_passe;
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white54,
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
      body: Container(
        child: Form(
          key: _key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InputText(hint: "Ancien mot de passe", onChanged: () => (value){
                setState(() {
                  ancien_mot_de_passe = value;
                });
              }, validator: () => (value){
                if(value == "" || value.isEmpty){
                  return "Veuillez saisir votre ancien mot de passe";
                }
              }, iconData: Icons.vpn_key, textInputType: TextInputType.text),
              InputText(hint: "Nouveau mot de passe", onChanged: () => (value){
                setState(() {
                  nouveau_mot_de_de_passe = value;
                });
              }, validator: () => (value){
                if(value == "" || value.isEmpty){
                  return "Veuillez saisir votre nouveau mot de passe";
                }
              }, iconData: Icons.vpn_key, textInputType: TextInputType.text),
              InputText(hint: "Confirmer votre mot de passe", onChanged: () => (value){
                setState(() {
                  comfirmer_mot_de_passe = value;
                });
              }, validator: () => (value){
                if(value == "" || value.isEmpty){
                  return "Veuillez saisir votre mot de passe de confirmation";
                }
              }, iconData: Icons.vpn_key, textInputType: TextInputType.text),
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
