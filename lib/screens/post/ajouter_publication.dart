import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/post_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AjouterPublication extends StatefulWidget {
  User user;
  AjouterPublication({required this.user});

  @override
  State<AjouterPublication> createState() => _AjouterPublicationState();
}

class _AjouterPublicationState extends State<AjouterPublication> {
  /** ---------- Déclarations des variables ---------------- **/
  List<XFile> images = [];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  User? users;
  String? description;
  bool loading = false;

  void _createPost() async {

    ApiResponse apiResponse = await createPost(description: description,images: images);

    if(apiResponse.error == null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil(user: users,)), (route) => false);
    }else if(apiResponse.error == avertissement){
      Navigator.pop(context);
      MessageAvertissement(context, "${apiResponse.data}");
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
      setState(() {
        loading = !loading;
      });
    }
  }

  void _editPost(int postId) async{
    ApiResponse apiResponse = await updatePost(postId, description!);

    if(apiResponse.error == null){

      Navigator.pop(context);

    }else if(apiResponse.error == unauthorized){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
      setState(() {
        loading = !loading;
      });
    }
  }

  Future<void> loadAssets() async{
    var status = await Permission.photos.request();

    if(!status.isGranted){
      List<XFile> resultList = [];

      try{
        resultList = await ImagePicker().pickMultiImage();
      }on Exception catch(e){
        print(e.toString());
      }
      if(!mounted) return;
      // setState(() {
      //   images = resultList;
      // });

      if (resultList.length + images.length <= 5) {
        setState(() {
          images.addAll(resultList);
        });
      } else {
        // Afficher un message d'erreur ou une alerte
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Center(child: Text('Limite atteinte', style: style_google,)),
              content: Center(child: Text('Vous ne pouvez sélectionner que 5 images au maximum.', style: style_google.copyWith(color: Colors.grey),)),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK', style: style_google.copyWith(color: Colors.lightBlue),),
                ),
              ],
            );
          },
        );
      }

    }else{
      print("L'utisateur a refusé l'autorisation");
    }
  }
  @override
  void initState() {
    users = widget.user;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
        ),
        title: Text("Ajouter une publication", style: style_google.copyWith(fontWeight: FontWeight.bold),),
        actions: [
          IconButton(onPressed: loadAssets, icon: Icon(Icons.image, color: Colors.green,))
        ],
      ),
      body: loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
            child: Column(
        children: [
               images.isNotEmpty
            ? buildCarousel()
            : Container(),
            //ElevatedButton(onPressed: loadAssets, child: Text("Sélectionner des images")),
            Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: TextFormField(
                  onChanged: (value) => setState(() {
                    description = value;
                  }),
                  keyboardType: TextInputType.multiline,
                  maxLines: 9,
                  validator: (value) =>
                  value!.isEmpty
                      ? "Veuillez remplir ce champ description"
                      : null,
                  decoration: InputDecoration(
                    labelText: "Description",
                    contentPadding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width - 20,
                  child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue
                    ),
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                         setState(() {
                           loading = !loading;
                           _createPost();
                         });
                      }
                    },
                    child: Text("Valider", style: TextStyle(color: Colors.white),),
                  ),
                ),
              ],
            )
        ],
      ),
          ),
    );
  }

  void removeImage(int index){
    setState(() {
      images.removeAt(index);
    });
  }

  int _currentIndex = 0;

  Widget buildCarousel(){
    return Column(
      children: [
        CarouselSlider(
            items: images.map((XFile image){
              return Builder(
                  builder: (BuildContext context){
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5),
                      child: Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Image.file(
                            File(image.path),
                            fit: BoxFit.cover,
                          ),
                          IconButton(onPressed: () => removeImage(images.indexOf(image)), icon: Icon(Icons.remove))
                        ],
                      ),
                    );
                  });
            }).toList(),
            options: CarouselOptions(
              aspectRatio: 16/9,
              viewportFraction: .8,
              enlargeCenterPage: true,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason){
                setState(() {
                  _currentIndex = index;
                });
              }
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index){
            return Padding(
                padding: EdgeInsets.all(4),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == _currentIndex ? Colors.blueGrey : Colors.grey
                  ),
                ),
            );
          }),
        )
      ],
    );
  }

  // Widget buildGridView(){
  //   return GridView.builder(
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 3,
  //         crossAxisSpacing: 4,
  //         mainAxisSpacing: 4
  //       ),
  //       itemCount: images.length,
  //       itemBuilder: (BuildContext context, index){
  //         return Stack(
  //           alignment: Alignment.topRight,
  //           children:[
  //             Image.file(
  //               File(images[index].path),
  //               width: 300,
  //               height: 300,
  //             ),
  //             IconButton(onPressed: () => removeImage(index), icon: Icon(Icons.remove))
  //           ]
  //         );
  //       });
  // }
}
