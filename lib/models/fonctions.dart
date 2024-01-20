import 'package:aeutna/models/user.dart';

class FonctionModel{

  int? id;
  String? fonctions;
  User? user;

  FonctionModel({
    this.id,
    this.fonctions,
    this.user
  });

  // function to convert json data to fonctions model
  factory FonctionModel.fromJson(Map<String, dynamic> a){
    return FonctionModel(
      id: a['id'],
      fonctions: a['fonctions'],
      user: User(
        id: a['users']['id'],
        pseudo: a['users']['pseudo'],
        image: a['users']['image'],
      ),
    );
  }
}