import 'package:aeutna/models/postImage.dart';

import 'user.dart';

class Post{

  int? id;
  String? description;
  List<PostImage>? images;
  int? likesCount;
  int? commentairesCount;
  User? user;
  bool? selfLiked;

  Post({
    this.id,
    this.description,
    this.images,
    this.likesCount,
    this.commentairesCount,
    this.user,
    this.selfLiked
  });

  // Map json to post model
  factory Post.fromJson(Map<String, dynamic> p){
    print(p);
    List<PostImage> images = [];
    if (p['images'] != null) {
      images = List<PostImage>.from(
        p['images'].map((imageJson) => PostImage.fromJson(imageJson)),
      );
    }

    return Post(
      id: p['id'],
      description: p['description'],
      images: images,
      likesCount: p['likes_count'],
      commentairesCount: p['commentaires_count'],
      user: User(
        id: p['users']['id'],
        pseudo: p['users']['pseudo'],
        image: p['users']['image'],
      ),
      selfLiked: p['likes'].length > 0,
    );
  }
}