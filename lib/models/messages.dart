import 'package:aeutna/models/user.dart';

class MessageModel{

  int? id;
  String? message;
  int? userId;
  int? receivedId;

  MessageModel({
    this.id,
    this.message,
    this.userId,
    this.receivedId
  });

  // function to convert json data to message model
  factory MessageModel.fromJson(Map<String, dynamic> a){
    return MessageModel(
      id: a['id'],
      message: a['message'],
      userId: a['users_id'],
      receivedId: a['users_receive']
    );
  }
}