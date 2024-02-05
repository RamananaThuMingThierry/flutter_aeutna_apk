import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/post.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

/** ---------------- Get alL Posts ---------------- **/
Future<ApiResponse> getAllPosts() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(postsURL);
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
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(response.body)['message'];
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
Future<ApiResponse> createPost({String? description, List<XFile>? images}) async{
  ApiResponse apiResponse = ApiResponse();

  print("Description $description et Image : ${images!.length}");

  try{
    String token = await getToken();
    var url = Uri.parse(postsURL);
    var request = http.MultipartRequest('POST', url);
    // Ajouter authorization et accept à l'en-tête de la requête
    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    // Ajouter les champs texte (description)
    request.fields['description'] = description!;
    if(images != null && images.isNotEmpty){
      // Ajoutez les images au corps de la requête
      for(var image in images){
        var stream = http.ByteStream(image.openRead());
        var length = await image.length();
        var multipartFile  = http.MultipartFile('images[]', stream, length, filename: 'image.jpg');
        request.files.add(multipartFile);
      }
    }

    // Envoyer la requête eet récupérez la réponse
    var rep = await http.Response.fromStream(await request.send());

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(rep.body)['errors'];
        errors.forEach((field, message) {
          errorMessages += "* ${message.join(', ')}\n";
        });
        apiResponse.data = errorMessages;
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
      case 304:
        apiResponse.error = info;
        apiResponse.data = pasDeChangement;
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 404:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(rep.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
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
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 404:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(rep.body)['message'];
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
      case 404:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(response.body)['message'];
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