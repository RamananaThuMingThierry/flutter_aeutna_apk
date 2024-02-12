import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/screens/profiles/updateProfile.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  User user;
  Profile({required this.user});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  User? data;

  @override
  void initState() {
    data = widget.user;
    super.initState();
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
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => UpdateProfile(user: data))))
              ],),
            SizedBox(height: 10,),
            UserInfo(users: data,)
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
              SizedBox(height: 10,),
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
  User? users;
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
                        )
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