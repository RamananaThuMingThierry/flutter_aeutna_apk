class PostImage {
  final int postId;
  final String imagePath;

  PostImage({required this.postId, required this.imagePath});

  factory PostImage.fromJson(Map<String, dynamic> json) {
    return PostImage(
      postId: json['post_id'],
      imagePath: json['image_path'],
    );
  }
}