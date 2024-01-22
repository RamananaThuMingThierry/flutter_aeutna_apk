import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/messages.dart';
import 'package:aeutna/models/users.dart';
import 'package:aeutna/services/message_services.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:aeutna/widgets/showDialog.dart';
import 'package:flutter/material.dart';

import '../auth/login.dart';

class SendMessage extends StatefulWidget {
  Users? users;

  SendMessage({this.users});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {

  List<dynamic> _messageList = [];
  Users? data;
  bool loading = true;
  Color? color;
  TextEditingController sms = TextEditingController();

  void _createMessage(String? message, int? userReceivedId) async{

    ApiResponse apiResponse = await createMessage(messages: message, idUserReceived: userReceivedId);

    if(apiResponse.error == null){
      sms.clear();
      _getMessage();
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${apiResponse.error}")));
    }
  }

  Future _getMessage() async{

    ApiResponse apiResponse = await showMessage(widget.users!.id);

    if(apiResponse.error == null){
      setState(() {
        _messageList = apiResponse.data as List<dynamic>;
        loading = false;
      });
    }else if(apiResponse.error == unauthorized){
      logout().then((value) => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (ctx) => Login()), (route) => false));
    }else{
      showDialog(
          context: context,
          builder: (BuildContext context) => MessageErreur(context, apiResponse.error)
      );
    }
  }

  @override
  void initState() {
    data = widget.users;
    _getMessage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.keyboard_backspace, color: Colors.blueGrey,),),
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50), // Image border
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(20), // Image radius
                      child: Image.asset('assets/photo.png', fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(width: 10,),
                Text("${data!.pseudo}", style: TextStyle(color: Colors.blueGrey),)
              ],
            ),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.phone_outlined, color: Colors.blueGrey,)),
              IconButton(onPressed: (){}, icon: Icon(Icons.email, color: Colors.blueGrey)),
              IconButton(onPressed: (){}, icon: Icon(Icons.more_vert, color: Colors.blueGrey)),
            ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8,),
          Expanded(
              child: loading
                  ? Center(child: CircularProgressIndicator(color: Colors.yellow,))
                  : RefreshIndicator(
                      child: ListView.builder(
                          itemCount: _messageList.length,
                          itemBuilder: (BuildContext context, int index){
                              MessageModel m = _messageList[index];
                              return Row(
                                mainAxisAlignment: m.receivedId == widget.users!.id ? MainAxisAlignment.end : MainAxisAlignment.start,
                                children: [
                                  Card(
                                    elevation: 1,
                                    child: Container(
                                        color: m.receivedId == widget.users!.id ? Colors.blue : Colors.blueGrey,
                                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                                        child: Expanded(child: Text("${m.message}", style: TextStyle(color: Colors.white),))),
                                  )
                                ],
                              );
                          }), 
                      onRefresh: () => _getMessage())
          ),
          Container(
              height: 60,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.black26, width: .5),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: sms,
                      keyboardType: TextInputType.text,
                      style: TextStyle(color: Colors.blueGrey),
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
                    ),
                  ),
                  IconButton(onPressed: (){
                    if(sms.text.isNotEmpty){
                      setState(() {
                        loading = true;
                      });
                      _createMessage(sms.text, widget.users!.id);
                    }
                  }, icon: Icon(Icons.send, color: color,))
                ],
              ),
          )
        ],
      ),
    );
  }
}
