import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/screens/admin/administrateurs.dart';
import 'package:aeutna/services/membres_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';

class ApprouverUtilisateurs extends StatefulWidget {
  Users users;
  ApprouverUtilisateurs({required this.users});

  @override
  State<ApprouverUtilisateurs> createState() => _ApprouverUtilisateursState();
}

class _ApprouverUtilisateursState extends State<ApprouverUtilisateurs> {
  Users? users;
  bool loading = true;
  List<Membres> _membresList = [];
  int selectMembreId = 0;
  Future _getallMembresNAPasUtilisateur() async{
    ApiResponse apiResponse = await getallMembresNAPasUtilisateur();

    if(apiResponse.error == null){
      List<dynamic> membresList = apiResponse.data as List<dynamic>;
      List<Membres> membres = membresList.map((p) => Membres.fromJson(p)).toList();
      setState(() {
        _membresList = membres;
        loading = loading ? !loading : loading;
      });

      if(_membresList.isEmpty){
        setState(() {
          selectMembreId = 0;
        });
      }else if(!_membresList.any((element) => element.id == selectMembreId)){
        setState(() {
          selectMembreId = _membresList.first.id!;
        });
      }

    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }


  @override
  void initState() {
    users = widget.users;
    _getallMembresNAPasUtilisateur();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.check_circle_outlined, color: Colors.blueGrey,))
        ],
        title: Text("Approuver un utilisateur", style: style_google.copyWith(fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                elevation: 0,
                shape: Border(
                  bottom: BorderSide(
                    width: 1,
                    color: Colors.blueGrey
                  )
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Row(
                        children: [
                          Icon(Icons.person_2_outlined, color: Colors.grey,),
                          SizedBox(width: 10,),
                          DropdownButton(
                              underline: SizedBox(height: 0,),
                              hint: Text("Sélectionner votre nom et prénom          ", style: style_google.copyWith(color: Colors.grey),),
                              value: selectMembreId,
                              items: [
                                DropdownMenuItem<int>(
                                    value: 0,
                                    child: Center(child: Text("Sélectionner votre nom et prénom", style: style_google,))
                                ),
                                ..._membresList.map<DropdownMenuItem<int>>((Membres membre){
                                  return DropdownMenuItem<int>(
                                      value: membre.id,
                                      child: Center(child: Text("${membre.nom} ${membre.prenom ?? ''}"!, style: style_google.copyWith(color: Colors.grey),))
                                  );
                                }).toList(),
                              ],
                              onChanged: (int? value){
                                setState(() {
                                  selectMembreId = value!;
                                });
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5, vertical: 0),
                child : Row(
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width - 10,
                        height: 40,
                        child: TextButton(onPressed: (){
                          approuverUser();
                          print("Valide!");
                        },style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.lightBlue)
                        ), child: Text("Valider", style: style_google.copyWith(color: Colors.white),))),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> approuverUser() async{
    ApiResponse apiResponse = await ValideUser(users!.id!, selectMembreId);
    if(apiResponse.error == null){
      Navigator.pop(context);
      MessageReussi(context, "${apiResponse.data}");
    }else if(apiResponse.error == avertissement){
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, apiResponse.error);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }
}
