import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/post.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:http/http.dart' as http;

/** ---------------- Get alL Posts ---------------- **/
Future<ApiResponse> getAllPosts() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(postsURL);
    print("*-------123--------- Url : $url et token : $token");
    final response = await http.get(
     url,
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $token'
      }
    );

   switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['posts'];
        apiResponse.data as List<dynamic>;
        print("Atooooooooooooooooooooooooh ${apiResponse.data}");
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

/** --------------- Créer un Post ----------------- **/
Future<ApiResponse> createPost({String? description, String? image}) async{
  ApiResponse apiResponse = ApiResponse();

  print("Description $description et Image : $image");

  try{
    String token = await getToken();
    var url = Uri.parse(postsURL);
    print("Url $url et Token $token");
    final rep = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
        'Authorization' : 'Bearer $token'
      },
      body: image != null
          ? {
        'description' : description,
        'image' : image,
          }
          :{
        'description': description
      }
    );

    print(rep.statusCode);

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body);
        break;
      case 422:
        final errors = jsonDecode(rep.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

/** --------------- Modifier un Post ----------------- **/
Future<ApiResponse> updatePost(int postId, String description) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.put(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'description': description
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

/** --------------- Supprimer un Post ----------------- **/
Future<ApiResponse> deletePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.delete(Uri.parse('$postsURL/$postId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}

/** ---------- Like or Dislike Post ---------------- **/
Future<ApiResponse> likeUnlikePost(int postId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse('$postsURL/$postId/likes');

    print("url : ${url}");

    final response = await http.post(
      url,
      headers: {
        'Accept' : 'application/json',
        'Authorization' : 'Bearer $token'
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }catch(e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}