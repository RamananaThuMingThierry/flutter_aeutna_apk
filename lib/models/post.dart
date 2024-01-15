import 'user.dart';

class Post{

  int? id;
  String? description;
  String? image;
  int? likesCount;
  int? commentairesCount;
  Users? user;
  bool? selfLiked;

  Post({
    this.id,
    this.description,
    this.image,
    this.likesCount,
    this.commentairesCount,
    this.user,
    this.selfLiked
  });

  // Map json to post model
  factory Post.fromJson(Map<String, dynamic> p){
    return Post(
      id: p['id'],
      description: p['description'],
      image: p['image'],
      likesCount: p['likes_count'],
      commentairesCount: p['commentaires_count'],
      user: Users(
        id: p['user']['id'],
        pseudo: p['user']['pseudo'],
        image: p['user']['image'],
      ),
      selfLiked: p['likes'].length > 0,
    );
  }
}