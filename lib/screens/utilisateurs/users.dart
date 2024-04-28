import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/onLoadingMembreShimmer.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/utilisateurs/showUsers.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/noResult.dart';
import 'package:flutter/material.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  // Déclarations des variables
  List<dynamic> _usersList = [];
  bool loading = true;
  String? recherche;
  bool _searchAutorisation = false;
  TextEditingController pseudo = TextEditingController();
  TextEditingController search = TextEditingController();

  Future _getallUsersValide() async{
    ApiResponse apiResponse = await getAllUsersValide();
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

  /** =============================================== Search User Valide ===================================== **/
  Future _searchUsersValide(String? search) async{
    ApiResponse apiResponse = await searchUserValide(search);
    if(apiResponse.error == null){
      setState(() {
        _usersList = apiResponse.data as List<dynamic>;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, apiResponse.error);
    }
  }


  @override
  void initState() {
    _getallUsersValide();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){
            if(_searchAutorisation){
              setState(() {
                search.clear();
                _searchAutorisation = !_searchAutorisation;
              });
              _getallUsersValide();
            }else{
              Navigator.pop(context);
            }
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          _searchAutorisation ? SizedBox() : IconButton(onPressed: (){
            setState(() {
              _searchAutorisation = !_searchAutorisation;
            });
          }, icon: Icon(Icons.search_outlined, color: Colors.blueGrey,))
        ],
        title: _searchAutorisation
            ? Container(
          width: double.infinity,
          height: 40,
          decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5)
          ),
          child: Center(
            child: TextFormField(
              controller: search,
              style: style_google.copyWith(color: Colors.white),
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search, color: Colors.white,),
                suffixIcon: IconButton(
                  onPressed: (){
                    _getallUsersValide();
                    setState(() {
                      search.clear();
                    });
                  },
                  icon: Icon(Icons.clear, color: Colors.redAccent,),
                ),
                hintText: "Recherche...",
                hintStyle: style_google.copyWith(color: Colors.white),
                border: InputBorder.none,
              ),
              onChanged: (value){
                setState(() {
                  recherche = value;
                });
                if(recherche!.isEmpty) {
                  _getallUsersValide();
                }else{
                  _searchUsersValide(recherche);
                }
              },
            ),
          ),
        )
        : Text("Liste des Utilisateurs", style: style_google.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: loading
          ? OnLoadingMembreShimmer()
          : RefreshIndicator(
              child: _usersList.length == 0
                      ?
                   NoResult()
                  :ListView.builder(
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
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ShowUsers(user: users!))),
                        leading: CircleAvatar(
                          backgroundImage: users.image == null ? AssetImage("assets/photo.png"): NetworkImage(users.image!) as ImageProvider,
                        ),
                        title: Text("${users.pseudo}", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 15),overflow: TextOverflow.ellipsis,),
                        subtitle: Text("${users.email}",style: style_google.copyWith(color: Colors.grey),overflow: TextOverflow.ellipsis,),
                        trailing: Icon(Icons.chevron_right, color: Colors.blueGrey,),
                      ),
                    );
                  }), onRefresh: (){
                return _getallUsersValide();
          })
    );
  }
}
