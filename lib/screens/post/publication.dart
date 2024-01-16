import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/post.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/post_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/btnLikeOrDisLike.dart';
import 'package:flutter/material.dart';

class Publication extends StatefulWidget {
  const Publication({Key? key}) : super(key: key);

  @override
  State<Publication> createState() => _PublicationState();
}

class _PublicationState extends State<Publication> {
  List<Post> _postList = [];
  int userId = 0;
  bool loading = true;

  Future retreivePosts() async{
    userId = await getUserId();
    ApiResponse apiResponse = await getAllPosts();

    print("Nous sommes iciiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiiii! ${apiResponse.data}");

    if(apiResponse.error == null){
      List<dynamic> postList = apiResponse.data as List<dynamic>;
      List<Post> posts = postList.map((p) => Post.fromJson(p)).toList();
      setState(() {
        _postList = posts;
        loading = loading ? !loading : loading;
      });
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  // Post like or dislike
  void handlePostLikeDislike(int postId) async {

    ApiResponse apiResponse = await likeUnlikePost(postId);
    print("Je suis là");
    if(apiResponse.error == null){
      retreivePosts();
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  // Delete Post
  void handleDeletePost(int postId) async{
    ApiResponse response = await deletePost(postId);
    if(response.error == null){
      retreivePosts();
    }else if(response.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${response.error}")));
    }
  }

  @override
  void initState() {
    retreivePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(child: CircularProgressIndicator(),)
        : RefreshIndicator(
      onRefresh: () {
        return retreivePosts();
      },
      child: ListView.builder(
        itemCount: _postList!.length,
        itemBuilder: (BuildContext context, int index){
          Post post = _postList![index];
          print(post.image);
          return Card(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                    image: post.user!.image != null
                                        ? DecorationImage(
                                        image: NetworkImage('${post.user!.image}'),
                                        fit: BoxFit.cover
                                    ) : null,
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.amber
                                ),
                              ),
                              SizedBox(width: 10,),
                              Text(
                                "${post.user!.pseudo}",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14
                                ),
                              )
                            ],
                          ),
                        ),
                        post.user!.id == userId
                            ?
                        PopupMenuButton(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.more_vert, color: Colors.black,),
                          ),
                          onSelected: (valeur){
                            if(valeur == "Modifier"){
                              // Modifier
                            }else{
                              // Supprimer
                              handleDeletePost(post.id ?? 0);
                            }
                          },
                          itemBuilder: (ctx) => [
                            PopupMenuItem(
                              child: Text("Modifier"),
                              value: "Modifier",
                            ),
                            PopupMenuItem(
                              child: Text("Supprimer"),
                              value: "Supprimer",
                            )
                          ],
                        )
                            :
                        SizedBox()
                      ],
                    ),
                    SizedBox(height: 12,),
                    post.image != null
                        ?
                    Column(
                      children: [
                        SizedBox(
                          child: Row(
                            children: [
                              Expanded(child: Text("${post.description}", textAlign: TextAlign.left,)),
                            ],
                          ),
                        ),
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: 180,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage('${post.image}'),
                                  fit: BoxFit.cover
                              ),
                            )
                        ),
                      ],
                    )
                        : Container(
                      constraints: BoxConstraints(
                        minHeight: 180.0, // Set a minimum height if needed
                      ),
                      color: Colors.blueGrey,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("${post.description}", style: TextStyle(color: Colors.white),textAlign: TextAlign.justify,),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        KBtnLikesOrComment(
                            value: post.likesCount ?? 0,
                            onTap: (){
                              print("Nous somme là!");
                              handlePostLikeDislike(post.id ?? 0);
                            },
                            iconData: post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
                            color: post.selfLiked == true ? Colors.red : Colors.grey),
                        Container(
                          height: 40,
                          width: .5,
                        ),
                        KBtnLikesOrComment(value: post.commentairesCount, onTap: (){
                        //  Navigator.push(context, MaterialPageRoute(builder: (ctx) => Commentaires(postId: post.id,)));
                        }, iconData: Icons.comment, color: Colors.grey),
                      ],
                    ),
                    Container(
                      height: .5,
                      color: Colors.black38,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ]
              )
          );
        },
      ),
    );
  }
}
