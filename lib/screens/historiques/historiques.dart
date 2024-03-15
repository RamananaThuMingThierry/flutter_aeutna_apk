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
                  SizedBox(height: 50,),
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("assets/logo.jpeg"),
                  ),
                  SizedBox(height: 50,),

                  Text("PREAMUBLE", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 18),),
                  SizedBox(height: 2,),
                  Container(
                    height: 2,
                    width: 100,
                    color: Colors.blueGrey,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: RichText(
                              textAlign: TextAlign.justify,
                              text: TextSpan(
                                children: [
                                  WidgetSpan(
                                    child: Text(
                                      "L'Association des Etudiants de l'Université de Tananarive Natifs d'Antalaha (AEUTNA)",
                                      textAlign: TextAlign.justify,
                                      style: style_google.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  TextSpan(
                                    text: " est une association à but non lucratif, régie par l'ordonnance 75-017 du 13 août 1975"
                                          " réglementant le régime général des associations à Madagascar. Elle a été créée en 1998"
                                          " par un groupe d'étudiants originaires d'Antalaha, afin de promouvoir la culture et le"
                                          " développement de leur ville natale. Cependant, elle est légalisée le 13 mars 1999 par"
                                          " les fondateurs",
                                    style: style_google,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "L'association est dirigée par un bureau composé d'un président, d'un trésorier(e) et d'un commissaire aux comptes.",
                            textAlign: TextAlign.justify,
                            style: style_google.copyWith(fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Les objectifs de l'association sont les suivants :",
                            textAlign: TextAlign.justify,
                            style: style_google,),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("Produire à son compte ainsi qu'à celui de ses membres toutes les activités,", style: style_google,),
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("Au Renforcement de l'amitié, l'entraide, et de la concorde des membres,", style: style_google,),
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("A la consolidation de l'entraide entre les originaires d'Antalaha,", style: style_google,),
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("A la promotion des activités et manifestations à caractères sociale, culturelle, et économique par le développement de la région d'Antalaha.", style: style_google,),
                  ),

                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "L'association organise différentes activités pour atteindre ses objectifs, notamment :",
                            textAlign: TextAlign.justify,
                            style: style_google,),
                        ),
                      ),
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("Des événements, tels que des exploitations et des conférences, etc...,", style: style_google,),
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("Des actions de solidarité, telles que des campagnes de sensibilisation, dons des livres, guide d'orientation aux lycées et aux collèges, etc...,", style: style_google,),
                  ),
                  ListTile(
                    leading: Icon(Icons.send, color: Colors.blueGrey),
                    title: Text("Des événements festifs, tels que des soirées étudiantes, sorties( pique-niques), etc..,", style: style_google,),
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "L'association est ouverte à tous les étudiants originaires d'Antalaha ni sympathisant, quel que soit leur cursus ou leur année d'études.",
                            textAlign: TextAlign.justify,
                            style: style_google.copyWith(fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
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
          listeDesPrisidents(image_path: "assets/flerio.jpg", nom: "JAO Flerio", date_mandat: "2018 - 2021"),
          listeDesPrisidents(image_path: "assets/romain.jpg", nom: "KOMODY ROMAIN", date_mandat: "2021 - 2023"),
          listeDesPrisidents(image_path: "assets/keini.jpg", nom: "Keini Morrodon", date_mandat: "2023 - à nos jours"),
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
