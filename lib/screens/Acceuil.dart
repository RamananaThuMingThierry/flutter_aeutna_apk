import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';

class Acceuil extends StatefulWidget {
  const Acceuil({Key? key}) : super(key: key);

  @override
  State<Acceuil> createState() => _AcceuilState();
}

class _AcceuilState extends State<Acceuil> {
  @override
  User? users;

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

  Widget build(BuildContext context) {
    return Scaffold(
      body: users == null
          ? Center(
        child: CircularProgressIndicator(),
          )
          : Center(
        child: Text("Email : ${users!.email!}"),
      ),
    );
  }
}
