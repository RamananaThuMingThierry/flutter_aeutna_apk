import 'user.dart';

class Commentaires{
  int? id;
  String? commentaire;
  User? user;

  Commentaires({this.id, this.commentaire, this.user});

  // Map json to comment Model
  factory Commentaires.fromJson(Map<String, dynamic> c){
    return Commentaires(
      id: c['id'],
      commentaire: c['commentaire'],
      user: User(
        id: c['user']['id'],
        pseudo: c['user']['pseudo'],
        image: c['user']['image']
      )
    );
  }
}