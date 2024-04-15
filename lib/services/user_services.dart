import 'dart:convert';
import 'dart:io';
import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/user.dart';
import 'package:aeutna/models/users.dart';
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

/** ---------------- Get alL Users ---------------- **/
Future<ApiResponse> getAllUsers() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(userURL+"_all");
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['user'].map((p) => Users.fromJson(p)).toList();
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

/** ---------------- Get alL Users En attente---------------- **/
Future<ApiResponse> getAllUsersEnAttente() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(userURL+"_en_attente");
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['user'].map((p) => Users.fromJson(p)).toList();
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

/** ---------------- Get alL Users Valide ---------------- **/
Future<ApiResponse> getAllUsersValide() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(userURL+"_valide");
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['user'].map((p) => Users.fromJson(p)).toList();
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

Future<ApiResponse> ValideUser(int userId) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(userURL+"_valide/${userId}");
   print(url);
    final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(response.body)['message'];
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

/** ============================================ Search User ========================================== **/
Future<ApiResponse> searchUserValide(String? valeur) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(userURL+"_valide_search/${valeur}");

    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['user'].map((p) => Users.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(response.body)['message'];
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


Future<ApiResponse> updateUser({String? image, String? pseudo, String? email, String? contact, String? adresse, int? userId}) async{
  ApiResponse apiResponse = ApiResponse();

  print(
      "pseudo : $pseudo \n"
      "email : $email \n"
      "adresse : $adresse \n"
      "contact  : $contact \n"
      "image : $image"
  );

  try{
    String token = await getToken();
    final response = await http.put(
      Uri.parse("$userURL/$userId"),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: {
        'image' : image,
        'pseudo' : pseudo,
        'email' : email,
        'adresse' : adresse,
        'contact' : contact
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
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

Future<ApiResponse> updateRolesUser({String? roles, int? userId}) async{
  ApiResponse apiResponse = ApiResponse();

  print(
      "rôles : $roles \n"
  );

  try{
    String token = await getToken();
    final response = await http.put(
        Uri.parse("${userURL}_role_user/$userId"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'roles' : roles
        }
    );

    print(" status : ${response.statusCode} et body : ${response.body}");

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
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

Future<ApiResponse> login({String? email, String? mot_de_passe}) async{
  ApiResponse apiResponse = ApiResponse();


  try{
    var url = Uri.parse(loginURL);
    print("Email : $email et Mot de passe : $mot_de_passe");
    print(url);

    final response = await http.post(
      url,
      headers: {
        'Accept': 'application/json',
      },
      body: {
        'email':email,
        'mot_de_passe': mot_de_passe
      }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(response.body)['errors'];
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

    print(e);

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

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(response.body)['errors'];
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
    print(e);
    apiResponse.error = serverError;
  }

  return apiResponse;
}

/** ----------------------- Changer le mot de passe ------------------------------------------------------------------------**/
Future<ApiResponse> updatePasswordUser({String? password_old, String? password_new}) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    var url = Uri.parse(changer_mot_de_passe);

    final response = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'ancien_mot_de_passe' : password_old,
          'nouveau_mot_de_passe' : password_new
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(response.body)['errors'];
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

/** --------------- Get base64 encoded image --------------------- **/
String? getStringImage(File? file){
  if(file == null) return null;
  return base64Encode(file.readAsBytesSync());
}

// Mot de passe oublier
Future<ApiResponse> mot_de_passe_oublier({String? email}) async{

  ApiResponse apiResponse = ApiResponse();

  try{
    var url = Uri.parse(forgetpasswordURL);

    final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'email' : email
        }
    );

    print("----------------- body : ${response.body}");

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['token'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(response.body)['errors'];
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

// Comfirmation
Future<ApiResponse> comfirmationEmail({String? nombre}) async{

  ApiResponse apiResponse = ApiResponse();

  try{

    print(nombre);

    var url = Uri.parse(comfirmationURL);

    final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'verification' : nombre
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(response.body)['errors'];
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

// Comfirmation
Future<ApiResponse> ReinitialiserMotDePasse({String? email, String? mot_de_passe, String? token}) async{

  ApiResponse apiResponse = ApiResponse();

  try{
    var url = Uri.parse(reinitialiser_mot_de_passeURL);

    final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json'
        },
        body: {
          'email' : email,
          'mot_de_passe' : mot_de_passe,
          'token' : token
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = avertissement;
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 422:
        apiResponse.error = avertissement;
        String errorMessages = "";
        final errors = jsonDecode(response.body)['errors'];
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
