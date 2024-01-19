import 'package:flutter/material.dart';

class NouvelConversation extends StatefulWidget {
  const NouvelConversation({Key? key}) : super(key: key);

  @override
  State<NouvelConversation> createState() => _NouvelConversationState();
}

class _NouvelConversationState extends State<NouvelConversation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey,
        title: Text("Nouvelle conversation"),
      ),
    );
  }
}
