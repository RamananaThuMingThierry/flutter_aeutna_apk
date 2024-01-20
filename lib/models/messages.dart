import 'package:aeutna/models/user.dart';

class MessageModel{

  int? id;
  String? message;
  User? user;
  User? user_received;

  MessageModel({
    this.id,
    this.message,
    this.user,
    this.user_received
  });

  // function to convert json data to message model
  factory MessageModel.fromJson(Map<String, dynamic> a){
    return MessageModel(
      id: a['id'],
      message: a['message'],
      user_received: a['users']['users_receive'],
      user: User(
        id: a['users']['id'],
        pseudo: a['users']['pseudo'],
        image: a['users']['image'],
      ),
    );
  }
}