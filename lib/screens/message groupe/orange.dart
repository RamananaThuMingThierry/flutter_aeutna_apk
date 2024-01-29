import 'package:aeutna/api/api_response.dart';
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
  List<String> phoneNumbers = ["0327563770", "0329790536","0325965197", "0382921685","0324060777","0327339964","0322274385","0328111011"];
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  RegExp regExp = RegExp(r'''
(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$''');

  // Future _getAllListPuceOrange(){
  //   ApiResponse apiResponse =
  // }

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
        backgroundColor: Colors.orange,
        title: Text("Orange", style: TextStyle(color: Colors.black),),
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
}
