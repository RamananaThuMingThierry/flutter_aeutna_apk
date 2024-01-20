import 'package:aeutna/models/user.dart';

class Avis{

  int? id;
  String? message;
  User? user;

  Avis({
    this.id,
    this.message,
    this.user
  });

  // function to convert json data to avis model
  factory Avis.fromJson(Map<String, dynamic> a){
    return Avis(
      id: a['id'],
      message: a['message'],
      user: User(
        id: a['users']['id'],
        pseudo: a['users']['pseudo'],
        image: a['users']['image'],
      ),
    );
  }
}