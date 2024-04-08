import 'package:aeutna/models/user.dart';

class FonctionModel{

  int? id;
  String? fonctions;

  FonctionModel({
    this.id,
    this.fonctions,
  });

  // function to convert json data to fonctions model
  factory FonctionModel.fromJson(Map<String, dynamic> a){
    return FonctionModel(
      id: a['id'],
      fonctions: a['nom_fonctions'],
    );
  }
}