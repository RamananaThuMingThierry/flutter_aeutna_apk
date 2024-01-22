import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/post.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/post/commentaires/commentaires.dart';
import 'package:aeutna/services/post_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/btnLikeOrDisLike.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        elevation: 1,
        shape: Border(
          bottom: BorderSide(width: .5, color: Colors.grey)
        ),
        title: Text("A.E.U.T.N.A", style: GoogleFonts.breeSerif(color: Colors.blueGrey)),
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(250), // Image border
              child: SizedBox.fromSize(
                size: Size.fromRadius(23), // Image radius
                child: Image.asset('assets/logo.jpeg', fit: BoxFit.cover),
              ),
            ),
          ),
        ],
      ),
      body: loading
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
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 6),
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
                                      ) : DecorationImage(
                                          image: AssetImage("assets/photo.png"),
                                          fit: BoxFit.cover
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.amber
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text(
                                  "${post.user!.pseudo}",
                                  style: GoogleFonts.daysOne(fontSize: 14),
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
                                Expanded(child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                  child: Text("${post.description}",style: GoogleFonts.roboto() ,textAlign: TextAlign.left,),
                                )),
                              ],
                            ),
                          ),
                          SizedBox(
                            child: Expanded(
                              child: CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: "${post!.image}",
                                placeholder: (context, url) => CircularProgressIndicator(color: Colors.blueGrey,), // Widget de chargement affiché pendant le chargement de l'image
                                errorWidget: (context, url, error) => Icon(Icons.error), // Widget d'erreur affiché si l'image ne peut pas être chargée
                              ),
                              //child: Image.network("${post.image}", fit: BoxFit.cover,)
                              ),
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
                            child: Text("${post.description}", style: GoogleFonts.roboto(color: Colors.white),textAlign: TextAlign.justify,),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          KBtnLikesOrComment(
                              value: post.likesCount ?? 0,
                              onTap: (){
                                handlePostLikeDislike(post.id ?? 0);
                              },
                              iconData: post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
                              color: post.selfLiked == true ? Colors.red : Colors.grey),
                          Container(
                            height: 40,
                            width: .5,
                          ),
                          KBtnLikesOrComment(
                              value: post.commentairesCount ?? 0, onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => CommentairesScreen(postId: post.id,)));
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
      ),
    );
  }
}
