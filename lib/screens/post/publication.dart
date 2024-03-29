import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/onLoadingPostShimmer.dart';
import 'package:aeutna/models/post.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/screens/post/commentaires/commentaires.dart';
import 'package:aeutna/services/post_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/btnLikeOrDisLike.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:google_fonts/google_fonts.dart';

class Publication extends StatefulWidget {
  User user;
  Publication({required this.user});

  @override
  State<Publication> createState() => _PublicationState();
}

class _PublicationState extends State<Publication> {
  List<Post> _postList = [];
  int userId = 0;
  bool loading = true;
  User? users;
  int _currentIndex = 0;

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
      ErreurLogin(context);
    }else{
     MessageErreurs(context, "${apiResponse.error}");
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
      MessageReussi(context, "${response.data}");
    }else if(response.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${response.error}");
    }
  }

  @override
  void initState() {
    users = widget.user;
    retreivePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        shape: Border(
            bottom: BorderSide(width: .5, color: Colors.grey)
        ),
        leading: widget.user.roles == "Administrateurs"
            ? IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,))
            :Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
              backgroundImage: AssetImage("assets/logo.jpeg"),
          ),
        ),
        elevation: 0,
        title: Text("A.E.U.T.N.A", style: style_google.copyWith(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        actions: [
          widget.user.roles == "Administrateurs"
              ?
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
            child: CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage("assets/logo.jpeg"),
            )
          ):
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
              child:   Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
                  child:  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey, // Couleur de fond par défaut
                    child: widget.user.image != null
                        ? CachedNetworkImage(
                      imageUrl: widget.user.image!,
                      placeholder: (context, url) => CircularProgressIndicator(),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                        : Icon(Icons.person), // Widget par défaut si imageUrl est null
                  )
              )
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child:  loading
                  ? OnLoadingPostShimmer()
                  :
              RefreshIndicator(
                onRefresh: () {
                  return retreivePosts();
                },
                child: _postList.length == 0
                    ? Center(child: Text("Aucun publication", style: style_google.copyWith(fontSize: 17, color: Colors.white),),)
                    : ListView.builder(
                  itemCount: _postList!.length,
                  itemBuilder: (BuildContext context, int index){
                    Post post = _postList![index];
                    return Card(
                        shape: Border(),
                        margin: EdgeInsets.symmetric(vertical: 2),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundImage: post.user!.image == null ? AssetImage("assets/photo.png") : NetworkImage(post.user!.image!) as ImageProvider,
                                ),
                                title: Text("${post.user!.pseudo}", style: style_google.copyWith(color: Colors.black87),),
                                subtitle: Text(formatTimeAgo(DateTime.parse(post.created_at!)), // Vous pouvez spécifier votre locale ici
                                  style: style_google.copyWith(color: Colors.grey),),
                                trailing: post.user!.id == userId
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
                                      showDialog(
                                          context: context!,
                                          barrierDismissible: true,
                                          builder: (BuildContext buildContext){
                                            return AlertDialog(
                                              backgroundColor: Colors.white,
                                              content: SizedBox(
                                                height: 65,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 20,),
                                                    Text("Voulez-vous vraiment supprimer cette publication ?", textAlign: TextAlign.center,style: style_google.copyWith(fontSize: 17),),
                                                  ],
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.only(top: 5.0, left: 5.0, right: 5.0),
                                              actions: [
                                                TextButton(
                                                    onPressed: (){
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Non", style: style_google.copyWith(color: Colors.red),)
                                                ),
                                                TextButton(
                                                    onPressed: (){
                                                    Navigator.pop(context);
                                                    handleDeletePost(post.id ?? 0);
                                                    },
                                                    child: Text("Oui",style: style_google.copyWith(color: Colors.lightBlue))),
                                              ],
                                            );
                                          });
                                    }
                                  },
                                  itemBuilder: (ctx) => [
                                    PopupMenuItem(
                                      child: RichText(
                                        text: TextSpan(
                                            style: style_google.copyWith(color: Colors.lightBlue),
                                            children: [
                                              WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 10), child: Icon(Icons.edit, color: Colors.lightBlue,),),),
                                              TextSpan(text: "Modifier", style: style_google.copyWith(fontSize: 16, color: Colors.lightBlue))
                                            ]
                                        ),
                                      ),
                                      value: "Modifier",
                                    ),
                                    PopupMenuItem(
                                      child: RichText(
                                        text: TextSpan(
                                            style: style_google.copyWith(color: Colors.red),
                                            children: [
                                              WidgetSpan(child: Padding(padding: EdgeInsets.only(right: 10), child: Icon(Icons.delete, color: Colors.red,),),),
                                              TextSpan(text: "Supprimer", style: style_google.copyWith(fontSize: 16, color: Colors.red))
                                            ]
                                        ),
                                      ),
                                      value: "Supprimer",
                                    )
                                  ],
                                )
                                    :
                                SizedBox(),
                              ),
                              post.images!.length != 0
                                  ?
                              Column(
                                children: [
                                  SizedBox(
                                    child: Row(
                                      children: [
                                        Expanded(child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          child: Text("${post.description}",style: style_google.copyWith(color: Colors.black87) ,textAlign: TextAlign.left,),
                                        )),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 300,
                                    child:  CarouselSlider(
                                      options: CarouselOptions(
                                        enableInfiniteScroll: false,
                                        height: screenHeight, // Utilisez la hauteur de l'écran comme hauteur du Carousel
                                        aspectRatio: screenWidth / screenHeight, // Maintient le rapport hauteur/largeur
                                        viewportFraction: 1.0, // Affiche une seule image à la fois
                                        enlargeCenterPage: true,
                                        onPageChanged: (index, reason){
                                          setState(() {
                                            _currentIndex = index;
                                          });
                                        }
                                      ),
                                      items: post.images!.asMap().entries.map((entry) {
                                        int index = entry.key + 1; // Start the index from 1
                                        var image = entry.value;
                                        return Builder(
                                          builder: (BuildContext context) {
                                            return Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                Image.network(image.imagePath, fit: BoxFit.cover,height: screenHeight,
                                                  width: screenWidth,),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                                  child: Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius: BorderRadius.circular(10)
                                                    ),
                                                    child: Text("${index} / ${post.images!.length}", style: style_google.copyWith(color: Colors.white),),
                                                  ),
                                                )
                                              ]
                                            );
                                          },
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              )
                                  :
                              Container(
                                constraints: BoxConstraints(
                                  minHeight: 180.0, // Set a minimum height if needed
                                ),
                                color: Colors.blueGrey,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("${post.description}", style: style_google.copyWith(color: Colors.white),textAlign: TextAlign.justify,),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                                child: Row(
                                  children: [
                                    KBtnLikesOrComment(
                                        value: post.likesCount ?? 0,
                                        onTap: (){
                                          handlePostLikeDislike(post.id ?? 0);
                                        },
                                        iconData: post.selfLiked == true ? Icons.favorite : Icons.favorite_outline,
                                        color: post.selfLiked == true ? Colors.red : Colors.grey),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: List.generate(post.images!.length, (index){
                                        return Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: index == _currentIndex ? Colors.blueGrey : Colors.grey
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                    KBtnLikesOrComment(
                                        value: post.commentairesCount ?? 0, onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => CommentairesScreen(postId: post.id,)));
                                    }, iconData: Icons.comment, color: Colors.grey),
                                  ],
                                ),
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
          )
        ],
      )
    );
  }
}
