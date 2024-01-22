import 'package:aeutna/widgets/ligne_horizontale.dart';
import 'package:flutter/material.dart';

Future Apropos(BuildContext context){
  return showModalBottomSheet(context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
      ),
      backgroundColor: Colors.blueGrey,
      builder: (ctx){
        return Container(
          child: Column(
            children: [
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outlined, color: Colors.white,),
                  SizedBox(width: 10,),
                  Text("Apropos", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 15),),
                ],
              ),
              Ligne(color: Colors.white,),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(80), // Image radius
                    child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: RichText(text: TextSpan(children: [
                  WidgetSpan(child: Text("A.E.U.T.N.A", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),)),
                  TextSpan(text: " est une Association des Etudiants à l'Université de Tananarivo Natifs d'Antalaha.", style: TextStyle(color: Colors.white,)),
                ])),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text("Cet application à pour but de faciliter l'enregistrement des membres AEUTNA et de partage information top sécrès.", style: TextStyle(color: Colors.white))
              ),
              SizedBox(height: 20,),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text("\"Zay tsy mihetsika tavela\"", style: TextStyle(color: Colors.white))
              ),
              Spacer(),
              Ligne(color: Colors.white),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Version : 1.25.1", style: TextStyle(color: Colors.white, fontSize: 15),),
                ],
              ),
              SizedBox(height: 10,),
            ],
          ),
        );
      });
}
