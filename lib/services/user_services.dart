import 'dart:convert';
import 'dart:io';
import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Get Token
Future<String> getToken() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// Get User Id
Future<int> getUserId() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getInt('userId') ?? 0;
}

// Logout
Future<bool> logout() async{
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.remove('token');
}

Future<ApiResponse> getUserDetail() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.get(
        Uri.parse(userURL),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
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

Future<ApiResponse> updateUser(String name, String? image) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    final response = await http.put(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: image == null
        ? {'name' : name}
        : {
        'name' : name,
        'image' : image
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

Future<ApiResponse> login({String? email, String? mot_de_passe}) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    var url = Uri.parse(loginURL);
    print(url);
    final response = await http.post(
      url,
      headers: {'Accept': 'application/json'},
      body: {
        'email':email,
        'mot_de_passe': mot_de_passe
      }
    );

    print(User.fromJson(jsonDecode(response.body)));

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.key.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
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

Future<ApiResponse> register({String? pseudo, String? email, String? mot_de_passe, String? contact, String? adresse}) async{
  ApiResponse apiResponse = ApiResponse();

  try{

    final response = await http.post(
        Uri.parse(registerURL),
        headers: {'Accept': 'application/json'},
        body: {
          'pseudo' : pseudo,
          'email': email,
          'contact': contact,
          'adresse': adresse,
          'mot_de_passe': mot_de_passe,
          'mot_de_passe_confirmation': mot_de_passe
        }
    );

    print(response.statusCode);

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.key.elementAt(0)][0];
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

/** --------------- Get base64 encoded image --------------------- **/
String? getStringImage(File? file){
  if(file == null) return null;
  return base64Encode(file.readAsBytesSync());
}