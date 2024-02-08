import 'package:aeutna/models/user.dart';

class SectionsModel{

  int? id;
  String? nom_sections;

  SectionsModel({
    this.id,
    this.nom_sections
  });

  // function to convert json data to avis model
  factory SectionsModel.fromJson(Map<String, dynamic> a){
    return SectionsModel(
      id: a['id'],
      nom_sections: a['nom_sections']
    );
  }
}