import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EnAttente extends StatefulWidget {
  User user;
  EnAttente({required this.user});

  @override
  State<EnAttente> createState() => _EnAttenteState();
}

class _EnAttenteState extends State<EnAttente> {
  User? user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(onPressed: (){
            deconnectionAlertDialog(context);
          }, icon: Icon(Icons.logout, color: Colors.blueGrey,))
        ],
      ),
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100,),
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/logo.jpeg"),
            ),
            Expanded(child: Column(
              children: [
                SizedBox(height: 45,),
                TitreText("Bienvenu, ",),
                SizedBox(height: 5,),
                Text("${user!.pseudo}", style: style_google.copyWith(color: Colors.black87),),
                SizedBox(height: 40,),
                SpinKitCubeGrid(
                  color: Colors.blueGrey,
                  size: 50,
                ),
                SizedBox(height: 40,),
                Text("Veuillez patientez... \n A l'approbation de l'administrateur", textAlign: TextAlign.center, style: style_google.copyWith(color: Colors.lightBlue),),
                ],
              ),
            ),
            Text('"Ensemble on obtient le succès"', style: style_google.copyWith(color: Colors.green),),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
