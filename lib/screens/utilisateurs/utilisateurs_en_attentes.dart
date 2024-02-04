import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/onLoadingMembreShimmer.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/utilisateurs/showUsers.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';

class UtilisateursEnAttentes extends StatefulWidget {
  const UtilisateursEnAttentes({Key? key}) : super(key: key);

  @override
  State<UtilisateursEnAttentes> createState() => _UtilisateursEnAttentesState();
}

class _UtilisateursEnAttentesState extends State<UtilisateursEnAttentes> {
  // Déclarations des variables
  List<dynamic> _usersList = [];
  bool loading = true;
  String? recherche;
  TextEditingController pseudo = TextEditingController();
  TextEditingController search = TextEditingController();

  Future _getallUsersEnAttente() async{
    ApiResponse apiResponse = await getAllUsersEnAttente();
    setState(() {
      pseudo.clear();
      search.clear();
    });
    if(apiResponse.error == null){
      setState(() {
        _usersList = apiResponse.data as List<dynamic>;
        search.clear();
        loading = false;
      });
    }else if(apiResponse.error == unauthorized){
      MessageErreurs(context, "${apiResponse.data}");
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }


  @override
  void initState() {
    _getallUsersEnAttente();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(_usersList.length);
    return Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.people_outline_outlined, color: Colors.blueGrey,))
          ],
          title: Text("Utilisateurs en attente", style: style_google.copyWith(fontWeight: FontWeight.bold),),
        ),
        body: loading
            ? OnLoadingMembreShimmer()
            : RefreshIndicator(
                child: _usersList.length == 0
                    ?  Center(
                  child: Text("Aucun résultat", style: style_google.copyWith(fontSize: 18, color: Colors.white),),
                )
                : ListView.builder(
                itemCount: _usersList.length,
                itemBuilder: (BuildContext context, int index){
                  Users users = _usersList[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 2,vertical: 2),
                    shape: Border(
                        left: BorderSide(
                            color: Colors.blueGrey,
                            width: 2
                        )
                    ),
                    elevation: 1,
                    child: ListTile(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowUsers(user: users))),
                      leading: Padding(
                        padding: EdgeInsets.all(10),
                        child: CircleAvatar(
                          backgroundImage: AssetImage("assets/photo.png"),
                        ),
                      ),
                      title: Text("${users.pseudo}", style: style_google.copyWith(fontWeight: FontWeight.bold),),
                      subtitle: Text("${users.email}",style: style_google.copyWith(fontSize: 14),),
                      trailing: Icon(Icons.chevron_right, color: Colors.blueGrey,),
                    ),
                  );
                }), onRefresh: (){
          return _getallUsersEnAttente();
        })
    );
  }
}
