import 'user.dart';

class Commentaires{
  int? id;
  String? commentaires;
  User? user;

  Commentaires({this.id, this.commentaires, this.user});

  // Map json to comment Model
  factory Commentaires.fromJson(Map<String, dynamic> c){
    return Commentaires(
      id: c['id'],
      commentaires: c['commentaires'],
      user: User(
        id: c['users']['id'],
        pseudo: c['users']['pseudo'],
        image: c['users']['image']
      )
    );
  }
}