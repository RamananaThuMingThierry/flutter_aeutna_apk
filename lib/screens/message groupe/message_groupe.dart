import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/screens/message%20groupe/airtel.dart';
import 'package:aeutna/screens/message%20groupe/orange.dart';
import 'package:aeutna/screens/message%20groupe/telma.dart';
import 'package:aeutna/screens/message%20groupe/tout.dart';
import 'package:aeutna/widgets/ItemChoixOperateurs.dart';
import 'package:flutter/material.dart';

class MessagesGroupes extends StatefulWidget {
  const MessagesGroupes({Key? key}) : super(key: key);

  @override
  State<MessagesGroupes> createState() => _MessagesGroupesState();
}

class _MessagesGroupesState extends State<MessagesGroupes> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace,color: Colors.blueGrey,),
        ),
        elevation: 0.5,
        title: Text("Choisir la carte SIM", style: style_google,),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.sim_card_outlined, color: Colors.blueGrey,))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 3,),
          ItemOperateurs(
              titre: "Airtel",
              onPressed: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => Airtel())), color: Colors.red),
          ItemOperateurs(
              titre: "Orange",
              onPressed: () => () =>  Navigator.push(context, MaterialPageRoute(builder: (ctx) => Orange())),
              color: Colors.orange),
          ItemOperateurs(
              titre: "Telma",
              onPressed: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => Telma())),
              color: Colors.green),
          ItemOperateurs(
              titre: "Toutes opérateurs",
              onPressed: () => () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ToutesOperateurs())),
              color: Colors.indigo),
        ],
      ),
    );
  }

}
