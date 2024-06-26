import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/filieres.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:http/http.dart' as http;

/** ---------------- Get alL Filieres ---------------- **/
Future<ApiResponse> getAllFilieres() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(filieresURL);
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['filieres'];
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

/** --------------- Créer un filieres ----------------- **/
Future<ApiResponse> createFilieres({String? nom_filieres}) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(filieresURL);
    final rep = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'nom_filieres': nom_filieres,
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
/** --------------- Show un filière ----------------- **/
Future<ApiResponse> showFilieres(int filieresId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    final rep = await http.get(Uri.parse('$filieresURL/$filieresId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = Filieres.fromJson(jsonDecode(rep.body)['filieres']);
        break;
      case 401:
        apiResponse.error = unauthorized;
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


/** --------------- Recherche un filière ----------------- **/
Future<ApiResponse> searchFilieres(String? nom_filieres) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    final rep = await http.get(Uri.parse("${filieresURL}_search/${nom_filieres}"),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['filieres'];
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

/** --------------- Modifier un filiere ----------------- **/
Future<ApiResponse> updateFilieres({int? filiereId, String? nom_filieres}) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.put(Uri.parse('$filieresURL/$filiereId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'nom_filieres': nom_filieres
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

/** --------------- Supprimer un filiere ----------------- **/
Future<ApiResponse> deleteFilieres(int filiereId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.delete(Uri.parse('$filieresURL/$filiereId'),
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
