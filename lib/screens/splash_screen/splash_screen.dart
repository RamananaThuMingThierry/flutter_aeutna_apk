import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/admin/administrateurs.dart';
import 'package:aeutna/screens/enattente.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';


class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen>{
  User? users;
  
  void _loading() async{
    String token = await getToken();
    print("Token $token");
    if(token == ''){
      ErreurLogin(context);
    }else{
      ApiResponse apiResponse = await getUserDetail();
      if(apiResponse.error == null){
        while(users == null){
          setState(() {
            users = apiResponse.data as User?;
          });
        }
        if(users!.status == 0){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => EnAttente(user: users!)), (route) => false);
        }else{
          if(users!.roles == "Administrateurs"){
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => AdministrateursScreen(user: users!)), (route) => false);
          }else{
            print("${users!.roles}");
            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) => Acceuil(user: users,)), (route) => false);
          }
        }
      }else if(apiResponse.error == unauthorized){
        ErreurLogin(context);
      }else{
        MessageErreurs(context, apiResponse.error);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loading();
  }

  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
    body: SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(250), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(100), // Image radius
                child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
              ),
            ),
          ),
          SizedBox(height: 45,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: Divider(color: Color(0xffE2C222),thickness: 1,)),
                Text("A.E.U.T.N.A", style: style_google.copyWith(fontSize: 25, fontWeight: FontWeight.bold)),
                Expanded(child: Divider(color: Color(0xffE2C222),thickness: 1,)),
              ],
            ),
          ),
          SizedBox(height: 30,),
          SpinKitThreeBounce(
            color: Colors.blueGrey,
            size: 30,
          ),
        ],
      ),
    ),
    );
  }
}