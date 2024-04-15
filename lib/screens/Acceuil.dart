import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/membres/membres.dart';
import 'package:aeutna/screens/profiles/profiles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Acceuil extends StatefulWidget {
  User? user;
  Acceuil({required this.user});

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  User? users;
  GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    users = widget.user;
    super.initState();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    List<Widget> page = [
      MembresScreen(user: users!),
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
      Profiles(user: users,),
    ];
    return
      Scaffold(
        key: _key,
        body: page[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          elevation: 1,
          onTap: (int index){
            setState(() {
              currentIndex = index;
            });
          },
          currentIndex: currentIndex,
          selectedItemColor: Colors.blueGrey,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          unselectedItemColor: Colors.grey,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
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
