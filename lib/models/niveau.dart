import 'package:aeutna/models/user.dart';

class Niveau{

  int? id;
  String? niveau;

  Niveau({
    this.id,
    this.niveau,
  });

  // function to convert json data to filières model
  factory Niveau.fromJson(Map<String, dynamic> a){
    return Niveau(
      id: a['id'],
      niveau: a['nom_niveau'],
    );
  }
}