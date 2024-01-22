import 'package:aeutna/screens/message%20groupe/airtel.dart';
import 'package:aeutna/screens/message%20groupe/orange.dart';
import 'package:aeutna/screens/message%20groupe/telma.dart';
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
        elevation: 0,
        title: Text("Choisir la carte SIM", style: TextStyle(color: Colors.blueGrey),),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.sim_card_outlined, color: Colors.blueGrey,))
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 5,),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: MaterialButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => Airtel()));
                    },
                    child: Text("Airtel", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                    color: Colors.red,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => Orange()));
                  },
                  child: Text("Orange", style: TextStyle(fontWeight: FontWeight.bold),),
                  color: Colors.orange,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => Telma()));
                  },
                  child: Text("Telma", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  color: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

}
