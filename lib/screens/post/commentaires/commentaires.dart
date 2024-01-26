import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:aeutna/constants/loadingShimmer.dart';
import 'package:aeutna/models/commentaires.dart';
import 'package:aeutna/screens/auth/login.dart';
import 'package:aeutna/services/commentaire_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:flutter/material.dart';

class CommentairesScreen extends StatefulWidget {
  // Déclarations des variables
  final int? postId;

  CommentairesScreen({this.postId});

  @override
  State<CommentairesScreen> createState() => _CommentairesState();

}

class _CommentairesState extends State<CommentairesScreen> {

  // Déclarations des variables
  List<dynamic> _commentList = [];
  bool loading = true;
  int userId = 0;
  int _editCommentId = 0;
  final TextEditingController commentaire = TextEditingController();
  Color? color;

  // Get Comments
  Future<void> _getComments() async{
    userId = await getUserId();

    ApiResponse apiResponse = await getCommentaires(widget.postId ?? 0);
    if(apiResponse.error == null){
      setState(() {
        _commentList = apiResponse.data as List<dynamic>;
        loading = loading ? !loading : loading;
      });
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void _createComment() async{
    ApiResponse apiResponse = await createCommentaire(postId: widget.postId ?? 0, commentaires: commentaire.text);

    if(apiResponse.error == null){
      commentaire.clear();
      _getComments();
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      setState(() {
        loading = false;
      });
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void _updateComment() async{
    ApiResponse apiResponse = await updateComment(_editCommentId, commentaire.text);

    if(apiResponse.error == null){
      _editCommentId = 0;
      commentaire.clear();
      _getComments();
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      setState(() {
        loading = false;
      });
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  void _deleteComment(int commentId) async{
    ApiResponse apiResponse = await deleteComment(commentId);
    if(apiResponse.error == null){
      _getComments();
    }else if(apiResponse.error == unauthorized){
      ErreurLogin(context);
    }else{
      setState(() {
        loading = false;
      });
      MessageErreurs(context, "${apiResponse.error}");
    }
  }

  @override
  void initState() {
    _getComments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            IconButton(onPressed: (){}, icon: Icon(Icons.message, color: Colors.blueGrey,))
          ],
        ),
        body: loading
            ?
            LoadingShimmer()
            : Column(
          children: [
            Expanded(child: RefreshIndicator(
              onRefresh: () => _getComments(),
              child: ListView.builder(
                  itemCount: _commentList.length,
                  itemBuilder: (BuildContext context, int index){
                    Commentaires commentaires = _commentList[index];
                    return Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white10,
                          border: Border(
                            bottom: BorderSide(color: Colors.black26, width: .5),
                          )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        image: commentaires.user!.image != null
                                            ? DecorationImage(image: NetworkImage('${commentaires.user!.image}'), fit: BoxFit.cover)
                                            : null,
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.blueGrey
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text("${commentaires.user!.pseudo}", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),),
                                ],
                              ),
                              commentaires.user!.id == userId
                                  ? PopupMenuButton(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: Icon(Icons.more_vert, color: Colors.black,),
                                ),
                                onSelected: (valeur){
                                  if(valeur == "Modifier"){
                                    // Modifier
                                    setState(() {
                                      _editCommentId = commentaires.id ?? 0;
                                      commentaire.text = commentaires.commentaires ?? '';
                                    });
                                  }else{
                                    // Supprimer
                                    _deleteComment(commentaires.id ?? 0);
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
                                  : SizedBox()
                            ],
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40),
                            child: Text("${commentaires.commentaires}"),)
                        ],
                      ),
                    );
                  }),
            )),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black26, width: .5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: commentaire,
                      onChanged: (value){
                        if(value.isEmpty){
                          setState(() {
                            color = Colors.grey;
                          });
                        }else{
                          setState(() {
                            color= Colors.blue;
                          });
                        }
                      },
                      decoration: InputDecoration(
                        label: Text("Rédigez un commentaire..."),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueGrey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  IconButton(onPressed: () {
                    if(commentaire.text.isNotEmpty){
                      setState(() {
                        loading = true;
                      });
                      _editCommentId == 0
                          ? _createComment()
                          : _updateComment();
                    }
                  }, icon: Icon(Icons.send, color: color))
                ],
              ),
            )
          ],
        )
    );
  }

}
