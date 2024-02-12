import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/screens/utilisateurs/approuverUtilisateurs.dart';
import 'package:aeutna/screens/utilisateurs/users.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';

class ShowUsers extends StatefulWidget {
  Users user;
  ShowUsers({required this.user});

  @override
  State<ShowUsers> createState() => _ShowUsersState();
}

class _ShowUsersState extends State<ShowUsers> {
  Users? data;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? roles;

  @override
  void initState() {
    data = widget.user;
    roles = data!.roles;
    super.initState();
  }


  Dialog userForm(BuildContext context){
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16)
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: Offset(0.0, 10.0)
              ),
            ]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Changer son rôle", style: style_google.copyWith(fontWeight: FontWeight.bold, fontSize: 15),),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(4),
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.close, color: Colors.blueGrey,),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15,),
            Form(
              key: _formKey,
              child: DropdownButton<String>(
                elevation: 0,
                hint: Text("Veuillez sélectionner votre rôle"),
                value: roles,
                onChanged: (String? newValue) {
                  setState(() {
                    roles = newValue!;
                  });
                },
                items: <String>['Administrateurs', 'Utilisateurs']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Center(child: Text(value, style: style_google.copyWith(color: Colors.grey),))
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 15,),
            GestureDetector(
              onTap: () async {
                if(_formKey.currentState!.validate()){
                  ApiResponse apiResponse = await updateRolesUser(roles: roles, userId: data!.id!);
                  if(apiResponse.error == null){
                    Navigator.push(context, MaterialPageRoute(builder: (ctx) => UsersScreen()));
                    MessageReussi(context,"${apiResponse.data}");
                  }else if(apiResponse.error == avertissement){
                    Navigator.pop(context);
                    MessageAvertissement(context, "${apiResponse.data}");
                  }else if(apiResponse.error == info){
                    Navigator.pop(context);
                    MessageInformation(context, "${apiResponse.data}");
                  }else if(apiResponse.error == unauthorized){
                    ErreurLogin(context);
                  }else {
                    Navigator.pop(context);
                    MessageErreurs(context, apiResponse.error);
                  }
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(2),
                ),
                padding: EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Center(
                  child: Text("Modifier", style:style_google.copyWith(color: Colors.white)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileHeader(
              coverImage: data!.image == null ? AssetImage("assets/photo.png") : NetworkImage(data!.image!) as ImageProvider,
              avatar: data!.image == null ? AssetImage("assets/photo.png") : NetworkImage(data!.image!) as ImageProvider,
              title: data!.pseudo!,
              actions: [
                MaterialButton(
                    color: Colors.white,
                    shape: CircleBorder(),
                    elevation: 0,
                    child: Icon(Icons.edit),
                    onPressed: () =>   showDialog(context: context, builder: (BuildContext context) => userForm(context))
                )
              ],),
            SizedBox(height: 10,),
            UserInfo(users: data,),
          ],
        ),
      ),
    );
  }
}


class ProfileHeader extends StatelessWidget{
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic>? avatar;
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  ProfileHeader({
    Key? key,
    required this.coverImage,
    this.avatar,
    required this.title,
    this.subtitle,
    this.actions
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Ink(
          height: 200,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: coverImage as ImageProvider,
                  fit: BoxFit.cover
              )
          ),
        ),
        Ink(
          height: 200,
          decoration: BoxDecoration(
              color: Colors.black38
          ),
        ),
        if(actions != null)
          Container(
            width: double.infinity,
            height: 200,
            padding: EdgeInsets.only(bottom: 0, right: 0),
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: actions!,
            ),
          ),
          Container(
          width: double.infinity,
          padding: EdgeInsets.only(top: 100),
          child: Column(
            children: [
              Avatar(
                  image: avatar as ImageProvider,
                  radius: 60,
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey.shade300,
                  borderWith: 4,
              ),
              Text(
                title,
                style: style_google
              ),
              if(subtitle != null)...[
                SizedBox(height: 5,),
                Text(
                  subtitle!,
                  style: style_google,
                ),
              ]
            ],
          ),
        ),
      ],
    );
  }
}

class Avatar extends StatelessWidget{
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWith;

  Avatar({
    Key? key,
    required this.image,
    this.backgroundColor,
    this.radius = 30,
    this.borderWith = 5,
    this.borderColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWith,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Colors.blueGrey,
        child: CircleAvatar(
          radius: radius - borderWith,
          backgroundImage: image as ImageProvider,
        ),
      ),
    );
  }
}

class UserInfo extends StatelessWidget{
  Users? users;
  UserInfo({this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 8, bottom: 4),
            alignment: Alignment.topLeft,
            child: Text("Information utilisateur", style: style_google.copyWith(fontWeight: FontWeight.w500, fontSize: 16),textAlign: TextAlign.left,),
          ),
          Card(
            shape: Border(),
            elevation: 1,
            child: Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  ...ListTile.divideTiles(
                      color: Colors.grey,
                      tiles: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12, vertical: 2
                          ),
                          title: Text("Pseudo", style: style_google.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.pseudo}"),
                          leading: Icon(Icons.account_circle_outlined, color: Colors.blueGrey,),
                        ),ListTile(
                          leading: Icon(Icons.mail_outline, color: Colors.blueGrey,),
                          title: Text("Adresse e-mail", style: style_google.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.email}"),
                        ),
                        ListTile(
                          leading: Icon(Icons.add_location, color: Colors.blueGrey,),
                          title: Text("Adresse", style: style_google.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.adresse}"),
                        ),
                        ListTile(
                          onTap: () => ActionsCallOrMessage(context, users!.contact),
                          leading: Icon(Icons.call_outlined, color: Colors.blueGrey,),
                          title: Text("Contact", style: style_google.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.contact}"),
                        ),
                        ListTile(
                          leading: Icon(Icons.person_2_outlined, color: Colors.blueGrey,),
                          title: Text("Rôles", style: style_google.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.roles}"),
                        ),
                        ListTile(
                          leading: Icon(users!.status == 0 ? Icons.disabled_by_default_outlined :  Icons.check_box, color: Colors.blueGrey,),
                          title: Text("Status", style: style_google.copyWith(fontWeight: FontWeight.w500),),
                          subtitle: Text("${users!.status == 0 ? "En attente" : "Membre"}"),
                          trailing: users!.status == 0
                              ? IconButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => ApprouverUtilisateurs(users: users!)))
                            ,
                            icon: Icon(Icons.check_circle_outlined, color: Colors.blueGrey,),
                          )
                              : SizedBox()
                        ),
                      ])
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

}