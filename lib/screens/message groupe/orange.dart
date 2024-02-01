import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/numero.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Orange extends StatefulWidget {
  const Orange({Key? key}) : super(key: key);

  @override
  State<Orange> createState() => _OrangeState();
}

class _OrangeState extends State<Orange> {

  // Déclarations des variables
  String? message;
  List<dynamic> _numeroList = [];
  List<String> phoneNumbers = [];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  Future _getAllListPuceOrange() async{
    ApiResponse apiResponse = await getAllNumero("032");
    if(apiResponse.error == null){
      setState(() {
        List<dynamic> numeroList = apiResponse.data as List<dynamic>;
        List<Numero> numero = numeroList.map((p) => Numero.fromJson(p)).toList();
        setState(() {
          _numeroList = numero;
        });
      });
      for(int i =0; i < _numeroList.length ; i++){
           setState(() {
             phoneNumbers.add(_numeroList[i].contact_personnel.toString());
           });
      }
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void sendBulkSMS(List<String> phoneNumbers, String message) async {
    String numbers = phoneNumbers.join(",");
    String smsUri = 'sms:$numbers?body=$message';

    if (await canLaunch(smsUri)) {
      await launch(smsUri);
    } else {
      print('Could not open SMS application.');
    }
  }

  @override
  void initState() {
    _getAllListPuceOrange();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text("Orange", style: style_google.copyWith(color: Colors.black),),
        elevation: 0,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.sim_card_outlined))
        ],
      ),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child:Form(
            key: _key,
            child: Container(
              child: Column(
                children: [
                  Card(
                      shape: Border(
                    //  bottom: BorderSide(color: Colors.orangeAccent, width: 2),
                    ),
                    elevation: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                      child: Row(
                        children: [
                          Text("Nombres : ", style: style_google.copyWith(color: Colors.orange),),
                          Text("Il y a ${phoneNumbers.length} numéro", style: style_google.copyWith(color: Colors.black54),),
                        ],
                      ),
                    ),
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 0, left: 5, right: 5),
                    elevation: 1,
                    shape: Border(),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Mot de passe
                          TextFormField(
                            enabled: phoneNumbers.length == 0 ? false : true,
                            onChanged: (value){
                              setState(() {
                                message = value;
                              });
                            },
                            validator: (value){
                              if(value!.isEmpty){
                                return "Veuillez saisir votre message!";
                              }
                            },
                            style: TextStyle(color: Colors.blueGrey),
                            decoration: InputDecoration(
                              hintText: "Rédiger votre message",
                              suffixIcon: Icon(Icons.message_outlined),
                              hintStyle: TextStyle(color: Colors.blueGrey),
                              suffixIconColor: Colors.grey,
                              enabledBorder : OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                              disabledBorder : OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors.grey
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red
                                )
                              )
                            ),
                            maxLines: 10,
                          ),
                          SizedBox(height: 5,),
                          //Button
                          InkWell(
                            onTap: () => validation(),
                            child: Container(
                              height: 40,
                              color: phoneNumbers.length == 0 ? Colors.grey : Colors.lightBlue,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Envoyer", style: style_google.copyWith(color: Colors.white, fontWeight: FontWeight.bold),),
                                  SizedBox(width: 10,),
                                  Icon(Icons.send,color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }

  void validation() async{
    final FormState _formkey = _key!.currentState!;
    if(_formkey.validate()){
      phoneNumbers.length == 0
          ? print("Il n'y a pas d'action")
          : sendBulkSMS(phoneNumbers, message!);
    }else{
      print("Non");
    }
  }
}
