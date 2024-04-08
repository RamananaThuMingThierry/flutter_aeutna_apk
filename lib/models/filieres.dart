import 'package:aeutna/models/user.dart';

class Filieres{

  int? id;
  String? nom_filieres;

  Filieres({
    this.id,
    this.nom_filieres,
  });

  // function to convert json data to filières model
  factory Filieres.fromJson(Map<String, dynamic> a){
    return Filieres(
      id: a['id'],
      nom_filieres: a['nom_filieres'],
    );
  }
}