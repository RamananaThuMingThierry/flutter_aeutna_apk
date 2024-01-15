import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/membres/membres.dart';
import 'package:aeutna/screens/messages/messages.dart';
import 'package:aeutna/screens/post/ajouter_publication.dart';
import 'package:aeutna/screens/post/publication.dart';
import 'package:aeutna/screens/profiles/profiles.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  User? users;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  void getUsers() async{
    ApiResponse apiResponse = await getUserDetail();
    print("ApiResponse : ${apiResponse.data}");
    if(apiResponse.error == null){
      setState(() {
        users = apiResponse.data as User?;
      });
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    List<Widget> page = [
      Publication(),
      Container(),
      Container(),
      Membres(),
      users == null
          ?
      Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitCircle(
              color: Colors.blueGrey,
              size: 50,
            ),
          ],
        ),
      )
          :
      Profiles(),
    ];

    return
      Scaffold(
        key: _key,
        body: page[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (int index){
            setState(() {
              currentIndex = index;
            });
            if(index == 1){
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => Messages()));
              setState(() {
                currentIndex = 0;
              });
            }
            if(index == 2){
              Navigator.push(context, MaterialPageRoute(builder: (ctx) => AjouterPublication()));
              setState(() {
                currentIndex = 0;
              });
            }
          },
          currentIndex: currentIndex,
          selectedItemColor: Colors.blueGrey,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: "Acceuil",
                backgroundColor: Colors.white
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.message_outlined),
              activeIcon: Icon(Icons.message),
              label: "Message",
            ),BottomNavigationBarItem(
              icon: Icon(Icons.add),
              activeIcon: Icon(Icons.add),
              label: "Publication",
            ),BottomNavigationBarItem(
                icon: Icon(Icons.people_alt_outlined),
                activeIcon: Icon(Icons.people),
                label: "Membres",
                backgroundColor: Colors.white
            ),BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              activeIcon: Icon(Icons.account_circle),
              label: "Profile",
            ),
          ],
        ),
      );
  }
}
