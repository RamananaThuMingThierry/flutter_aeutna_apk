import 'package:aeutna/models/user.dart';

class Filieres{

  int? id;
  String? nom_filieres;
  User? user;

  Filieres({
    this.id,
    this.nom_filieres,
    this.user
  });

  // function to convert json data to filières model
  factory Filieres.fromJson(Map<String, dynamic> a){
    return Filieres(
      id: a['id'],
      nom_filieres: a['nom_filieres'],
      user: User(
        id: a['users']['id'],
        pseudo: a['users']['pseudo'],
        image: a['users']['image'],
        contact: a['users']['contact']
      ),
    );
  }
}