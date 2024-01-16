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
  String? nom;
  String? email;
  String? contact;
  String? message;
  List<String> phoneNumbers = ["0327563770", "0329790536","0325965197", "0382921685","0324060777","0327339964","0322274385","0328111011"];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Contactez-nous", style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.message_outlined))
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
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Mot de passe
                        TextFormField(
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
                            hintText: "Message",
                            suffixIcon: Icon(Icons.message_outlined),
                            hintStyle: TextStyle(color: Colors.blueGrey),
                            suffixIconColor: Colors.grey,
                            enabledBorder : UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.grey
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
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
                    width: 325,
                    child: Button(
                        color: Colors.lightBlue,
                        onPressed: () => validation,
                        name: "Envoyer"),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Expanded(child: Divider(color: Colors.blueGrey,thickness: 1,)),
                        Text(" Or ", style: GoogleFonts.roboto(color: Colors.brown, fontSize: 15),),
                        Expanded(child: Divider(color: Colors.blueGrey,thickness: 1,)),
                      ],
                    ),
                  ),
                  SizedBox(height: 5,),
                  //Button
                  Container(
                    width: 325,
                    child: Button(
                        color: Colors.blueGrey,
                        onPressed: () => () => _AppellezNous(numero: "+261 32 75 637 70", action: "tel")
                        ,
                        name: "Appellez-nous"),
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
      sendBulkSMS(phoneNumbers, message!);
    }else{
      print("Non");
    }
  }

  void _AppellezNous({String? numero, String? action}) async {
    final Uri url = Uri(
        scheme: action,
        path: numero
    );
    if(await canLaunchUrl(url)){
      await launchUrl(url);
    }else{
      print("${url}");
    }
  }
}
