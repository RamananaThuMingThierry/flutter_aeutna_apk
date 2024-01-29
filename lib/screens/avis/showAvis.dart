import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/avis.dart';
import 'package:flutter/material.dart';

class ShowAvisScreen extends StatefulWidget {
  Avis? avis;
  ShowAvisScreen({this.avis});

  @override
  State<ShowAvisScreen> createState() => _ShowAvisScreenState();
}

class _ShowAvisScreenState extends State<ShowAvisScreen> {
  Avis? avis;

  @override
  void initState() {
    avis = widget.avis;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: .5,
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.keyboard_backspace,color: Colors.blueGrey,),),
        title: Text("${avis!.user!.pseudo}", style: style_google,),
        actions: [
          Padding(
              padding: EdgeInsets.all(10),
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/photo.png"),
              ),
          ),
        ],
      ),
      body: Column(
        children: [
          Card(
            color: Colors.blueGrey,
            elevation: 1,
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Expanded(
                      child: Text("${avis!.message}", style: style_google.copyWith(color: Colors.white),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
