import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class HistoriquesScreen extends StatefulWidget {
  const HistoriquesScreen({Key? key}) : super(key: key);

  @override
  State<HistoriquesScreen> createState() => _HistoriquesScreenState();
}

class _HistoriquesScreenState extends State<HistoriquesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: TitreText("Historiques"),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.location_history_rounded, color: Colors.blueGrey,))
        ],
      ),
      body: ListView(
        children: [
          Card(
            elevation: 1,
            margin: EdgeInsets.symmetric(vertical: 1),
            shape: Border(),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(height: 100,),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/logo.jpeg"),
                  ),
                  SizedBox(height: 50,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RichText(
                      text: TextSpan(
                        children: [
                          WidgetSpan(child: Text("A.E.U.T.N.A" , style: style_google.copyWith(fontWeight: FontWeight.bold),)),
                          TextSpan(text: " est une Association des Etudiants Universitaires Natifs d'Antalaha fondé en 1999.", style: style_google)
                        ]
                      ),
                    ),
                  ),
                  SizedBox(height: 30,),
                  Text("Les présidents en successions", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 18),),
                  SizedBox(height: 2,),
                  Container(
                    height: 2,
                    width: 100,
                    color: Colors.blueGrey,
                  ),
                  SizedBox(height: 30,)
                ],
            ),
          ),
          listeDesPrisidents(image_path: "assets/logo.jpeg", nom: "Hyacinte", date_mandat: "2013 - 2018"),
          listeDesPrisidents(image_path: "assets/logo.jpeg", nom: "JAO Flerio", date_mandat: "2018 - 2021"),
          listeDesPrisidents(image_path: "assets/logo.jpeg", nom: "KOMODY ROMAIN", date_mandat: "2021 - 2023"),
          listeDesPrisidents(image_path: "assets/logo.jpeg", nom: "Keini Morrodon", date_mandat: "2023 - à nos jours"),
        ],
      ),
    );
  }

  Card listeDesPrisidents({String? image_path, String? nom, String? date_mandat}){
    return Card(
      elevation: 1,
      margin: EdgeInsets.symmetric(vertical: 1),
      shape: Border(
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.blueGrey,
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(image_path!),
          ),
        ),
        title: Text(nom!, style: style_google.copyWith(fontWeight: FontWeight.bold),),
        subtitle: Text(date_mandat!, style: style_google.copyWith(color: Colors.grey),),
      ),
    );
  }
}
