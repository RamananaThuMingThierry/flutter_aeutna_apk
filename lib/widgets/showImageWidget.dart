import 'package:flutter/material.dart';

class ShowImageWidget extends StatelessWidget {
  final String image;
  const ShowImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        elevation: 0,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Container(
            child: Image.asset(image),
        ),
      ),
    );
  }
}
