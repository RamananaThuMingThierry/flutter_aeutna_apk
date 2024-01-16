import 'dart:io';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/screens/Acceuil.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/post_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AjouterPublication extends StatefulWidget {
  const AjouterPublication({Key? key}) : super(key: key);

  @override
  State<AjouterPublication> createState() => _AjouterPublicationState();
}

class _AjouterPublicationState extends State<AjouterPublication> {
  /** ---------- Déclarations des variables ---------------- **/
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? description;
  bool loading = false;
  File? imageFile = null;
  final _picker = ImagePicker();

  Future getImage() async{
    final pickerFile = await _picker.pickImage(source: ImageSource.gallery);
    if(pickerFile != null){
      setState(() {
        imageFile = File(pickerFile.path);
      });
    }
  }

  void _createPost() async {
    String? image = imageFile == null ? null : getStringImage(imageFile);
    ApiResponse apiResponse = await createPost(description: description,image: image);
    if(apiResponse.error == null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil()), (route) => false);
    }else if(apiResponse.error == unauthorized){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Ajouter une publication", style: TextStyle(color: Colors.grey),),
        centerTitle: true,
      ),
      body: loading
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            decoration: BoxDecoration(
              image: imageFile == null
                  ? null
                  : DecorationImage(
                  image: FileImage(imageFile ?? File('')),
                  fit: BoxFit.cover
              ),
            ),
            child: Center(
              child: IconButton(
                icon: Icon(Icons.image, size: 50, color: Colors.black38,),
                onPressed: (){
                  getImage();
                },
              ),
            ),
          ),
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
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 170,
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
              SizedBox(width: 10,),
              Container(
                width: 170,
                child: TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.red
                  ),
                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Acceuil()), (route) => false);
                  },
                  child: Text("Annuler", style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
