import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/services/avis_services.dart';
import 'package:aeutna/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NousContactez extends StatefulWidget {
  const NousContactez({Key? key}) : super(key: key);

  @override
  State<NousContactez> createState() => _NousContactezState();
}

class _NousContactezState extends State<NousContactez> {
  // Déclarations des variables;
  TextEditingController message = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        title: Text("Contactez-nous", style: style_google.copyWith(fontWeight: FontWeight.bold),),
        backgroundColor: Colors.white,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.help_outline, color: Colors.blueGrey,))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child:Form(
            key: _key,
            child: Container(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mot de passe
                        TextFormField(
                          controller: message,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Veuillez saisir votre message!";
                            }
                          },
                          style: TextStyle(color: Colors.blueGrey),
                          decoration: InputDecoration(
                            hintText: "Rédiger votre message...",
                            suffixIcon: Icon(Icons.message_outlined),
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            suffixIconColor: Colors.grey,
                            enabledBorder : OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.blueGrey,
                              ),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red,
                              ),
                            ),
                          ),
                          maxLines: 10,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  //Button
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: MediaQuery.of(context).size.width,
                    child: Button(
                        color: Colors.lightBlue,
                        onPressed: () => validation,
                        name: "Envoyer"),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey,thickness: 1,)),
                        Text(" Or ", style: GoogleFonts.roboto(color: Colors.blueGrey, fontSize: 15),),
                        Expanded(child: Divider(color: Colors.grey,thickness: 1,)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  //Button
                  Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                        child: TextButton.icon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blueGrey)
                            ),
                            onPressed: (){
                          ContactezNous(numero: "+261 32 75 637 70", action: "tel");
                        }, icon: Icon(Icons.phone_outlined, color: Colors.white,), label: Text("Contactez-nous", style: style_google.copyWith(color: Colors.white),),
                    )
                  )
                ],
              ),
            ),
          )
      ),
    );
  }

  void _createAvis() async {
    ApiResponse apiResponse = await createAvis(message: message.text);
    setState(() {
      message.clear();
    });
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, apiResponse.error);
      ErreurLogin(context);
    }else{
      Navigator.pop(context);
      MessageErreurs(context, apiResponse.error);
    }
  }

  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      AutorisationAlertDialog(context: context, message: "Vous êtes sûr?", onLoading: () => _createAvis);
    }else{
      print("Non");
    }
  }
}
