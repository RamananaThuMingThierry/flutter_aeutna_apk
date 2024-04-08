import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/niveau.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:http/http.dart' as http;

/** ---------------- Get alL Niveau ---------------- **/
Future<ApiResponse> getAllNiveau() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(niveauURL);
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['niveau'];
        apiResponse.data as List<dynamic>;
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

/** --------------- Créer un niveau ----------------- **/
Future<ApiResponse> createNiveau({String? niveau}) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(niveauURL);
    final rep = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'nom_niveau': niveau,
        }
    );

    print(jsonDecode(rep.body)['message']);

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

/** --------------- Show un Niveau ----------------- **/
Future<ApiResponse> showNiveau(int niveauId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    final rep = await http.get(Uri.parse('$niveauURL/$niveauId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = Niveau.fromJson(jsonDecode(rep.body)['niveau']);
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

/** --------------- Recherche un niveau ----------------- **/
Future<ApiResponse> searchNiveau(String? niveau) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${niveauURL}_search/${niveau}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['niveau'];
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

/** --------------- Modifier un niveau ----------------- **/
Future<ApiResponse> updateNiveau({int? niveauId, String? niveau}) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.put(Uri.parse('$niveauURL/$niveauId'),
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'nom_niveau': niveau
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

/** --------------- Supprimer un niveau ----------------- **/
Future<ApiResponse> deleteNiveau(int niveauId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.delete(Uri.parse('$niveauURL/$niveauId'),
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
