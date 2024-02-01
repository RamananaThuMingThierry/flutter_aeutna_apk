import 'dart:convert';

import 'package:aeutna/api/api_response.dart';
import 'package:aeutna/constants/constants.dart';
import 'package:aeutna/models/membres.dart';
import 'package:aeutna/services/user_services.dart';
import 'package:http/http.dart' as http;

/** ---------------- Get alL Membres ---------------- **/
Future<ApiResponse> getAllMembres() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(membresURL);
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['membres'];
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

/** ---------------- Get Numéro ---------------------**/
Future<ApiResponse> getAllNumero(String? prefixNumero) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse("${membresURL}_numero/${prefixNumero}");
    final response = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    print("- status : ${response.statusCode }---------- ${jsonDecode(response.body)['membres']}");

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['membres'];
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

/** --------------- Créer un Membres ----------------- **/
Future<ApiResponse> createAxes({
  int? numero_carte,
  String? nom,
  String? prenom,
  String? date_de_naissance,
  String? lieu_de_naissance,
  String? cin,
  String? genre,
  String? contact_personnel,
  String? contact_tutaire,
  bool? sympathisant,
  int? axesId,
  int? filieres_id,
  int? niveau_id,
  int? fonctions_id,
  String? facebook,
  String? adresse,
  String? date_inscription
}) async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(membresURL);
    final rep = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'numero_carte': numero_carte,
          'nom' : nom,
          'prenom' : prenom,
          'date_de_naissance' : date_de_naissance,
          'lieu_de_niassence' : lieu_de_naissance,
          'cin' : cin,
          'genre' : genre,
          'contact_personnel': contact_personnel,
          'contact_tutaire' : contact_tutaire,
          'sympathisant' : sympathisant,
          'axes_id': axesId,
          'filieres_id': filieres_id,
          'fonctions_id': fonctions_id,
          'levels_id': niveau_id,
          'facebook': facebook,
          'adresse':adresse,
          'date_inscription': date_inscription
        }
    );

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
      case 403:
        apiResponse.error = jsonDecode(rep.body)['message'];
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

/** --------------- getMembres ----------------------- **/
Future<ApiResponse> getMembres(int membreId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    var url = Uri.parse("$baseURL/getmembres/$membreId");
    final rep = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
          apiResponse.data = Membres.fromJson(jsonDecode(rep.body)['membres']);
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

/** --------------- Supprimer un membre ----------------- **/
Future<ApiResponse> deleteMembres(int membreId) async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    final rep = await http.delete(Uri.parse('$membresURL/$membreId'),
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
