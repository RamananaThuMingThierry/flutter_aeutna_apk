import 'package:aeutna/models/user.dart';

class Niveau{

  int? id;
  String? niveau;
  User? user;

  Niveau({
    this.id,
    this.niveau,
    this.user
  });

  // function to convert json data to filières model
  factory Niveau.fromJson(Map<String, dynamic> a){
    return Niveau(
      id: a['id'],
      niveau: a['niveau'],
      user: User(
          id: a['users']['id'],
          pseudo: a['users']['pseudo'],
          image: a['users']['image']
      ),
    );
  }
}