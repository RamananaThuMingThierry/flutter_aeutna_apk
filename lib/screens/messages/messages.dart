import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/messages/nouvel_conversation.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  User? user;

  Messages({required this.user});

  @override
  State<Messages> createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TitreText("Messages"),
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(16), // Image radius
                child: widget.user!.image == null ? Image.asset('assets/photo.png') : Image.network('${widget.user!.image!}', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Text("Démarrer votre discussions", style: style_google,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (ctx) => NouvelConversation()));
        },
        child: Icon(Icons.message_outlined),
      ),
    );
  }
}
