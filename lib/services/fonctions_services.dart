import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/fonctions.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:http/http.dart' as http;

/** ---------------- Get alL Fonctions ---------------- **/
Future<ApiResponse> getAllFonctions() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(fonctionsURL);
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    print("------------------------------------------ fonctions : ${response.body} ---------------");

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['fonctions'];
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

/** --------------- Créer une Fonction ----------------- **/
Future<ApiResponse> createFonctions({String? fonctions}) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(fonctionsURL);
    final rep = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'nom_fonctions': fonctions,
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
        apiResponse.error = jsonDecode(rep.body)['message'];
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

/** --------------- Show un fonctions ----------------- **/
Future<ApiResponse> showFonctions(int fonctionsId) async{

  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.get(Uri.parse('$fonctionsURL/$fonctionsId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
    switch(rep.statusCode){
      case 200:
        apiResponse.data = FonctionModel.fromJson(jsonDecode(rep.body)['fonctions']);
        break;
      case 401:
        apiResponse.error = unauthorized;
        apiResponse.data = jsonDecode(rep.body)['message'];
        break;
      case 403:
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

/** --------------- Recherche un fonctions ----------------- **/
Future<ApiResponse> searchFonctions(String? fonctions) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${fonctionsURL}_search/${fonctions}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['fonctions'];
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
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

/** --------------- Modifier un fonctions ----------------- **/
Future<ApiResponse> updateFonctions({int? fonctionId, String? fonctions}) async{
  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    final rep = await http.put(Uri.parse('$fonctionsURL/$fonctionId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'nom_fonctions': fonctions
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
        apiResponse.error = jsonDecode(rep.body)['message'];
        break;
      case 404:
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

/** --------------- Supprimer un fonctions ----------------- **/
Future<ApiResponse> deleteFonctions(int fonctionId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.delete(Uri.parse('$fonctionsURL/$fonctionId'),
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
