import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/messages/sendMessage.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';

class NouvelConversation extends StatefulWidget {
  const NouvelConversation({Key? key}) : super(key: key);

  @override
  State<NouvelConversation> createState() => _NouvelConversationState();
}

class _NouvelConversationState extends State<NouvelConversation> {
  // Déclarations des variables
  String? recherche;
  bool loading = true;
  List<dynamic> _usersList = [];

  Future _getallUsers() async{

    ApiResponse apiResponse = await getAllUsers();
    if(apiResponse.error == null){
      setState(() {
        _usersList = apiResponse.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });

    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  @override
  void initState() {
    _getallUsers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.message, color: Colors.blueGrey,)),
        ],
        title: Text("Nouvelle conversation", style: TextStyle(color: Colors.blueGrey),),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        children: [
          Card(
            elevation: 1,
            shape: Border(
                bottom: BorderSide(color: Colors.grey, width: .5)),
            margin: EdgeInsets.all(0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal:3, vertical: 5),
              height: 50,
              child: TextFormField(
                style: TextStyle(color: Colors.blueGrey),
                onChanged: (value){
                  setState(() {
                    recherche = value;
                  });
                },
                validator:(value){
                  if(value == ""){
                    return "Veuillez saisir le nom à recherche";
                  }
                },
                decoration: InputDecoration(
                  filled: true,
                  hintText: "Recherche",
                  hintStyle: TextStyle(color: Colors.blueGrey),
                  fillColor: Colors.white,
                  suffixIcon: Icon(Icons.search),
                  suffixIconColor: Colors.grey,
                  enabledBorder : UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
          ),
          Expanded(child: loading
              ?
          Center(
            child: CircularProgressIndicator(color: Colors.blueGrey,),
          )
              :
          RefreshIndicator(
              child: ListView.builder(
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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (ctx) => SendMessage(users: users,)));
                          print("Salut");
                        },
                        leading: Padding(
                          padding: EdgeInsets.all(10),
                          child: CircleAvatar(
                            backgroundImage: AssetImage("assets/photo.png"),
                          ),
                        ),
                        title: Text("${users.pseudo}", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 15),),
                        trailing: Icon(Icons.chevron_right, color: Colors.blueGrey,),
                      ),
                    );
                  }), onRefresh: (){
            return _getallUsers();
          })
          ),
        ],
      ),
    );
  }
}
