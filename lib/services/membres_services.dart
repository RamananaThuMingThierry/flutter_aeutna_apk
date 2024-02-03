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

/** ---------------- Get alL Membres ---------------- **/
Future<ApiResponse> getallMembresNAPasUtilisateur() async{
  ApiResponse apiResponse = ApiResponse();

  try{
    String token = await getToken();
    var url = Uri.parse(membresURL+"_getAllUsersNonPasUtilisateurs");
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
Future<ApiResponse> createMembre({
  String? image,
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
    print(url);
    print(token);
    print(
        "image : $image \n"
        "Numéro carte : $numero_carte \n"
        "Nom : $nom \n"
        "Prénom : $prenom \n"
        "Date de naissance : $date_de_naissance \n"
        "Lieu de naissance : $lieu_de_naissance \n"
        "CIN : $cin \n"
        "Genre : $genre \n"
        "Contact personnel $contact_personnel \n"
        "Contact tuteur : $contact_tutaire \n"
        "Sympathisant : ${sympathisant == true ? 1 : 0} \n"
        "Axes_id : $axesId \n"
        "Filiere_id :$filieres_id \n"
        "Fonctions_id : $fonctions_id \n"
        "Niveau_id : $niveau_id \n"
        "Facebook : $facebook \n"
        "Adresse : $adresse \n"
        "Date d'inscription : $date_inscription"
    );
    final rep = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
              'image' : image,
              'numero_carte': numero_carte.toString(),
               'nom' : nom,
              'prenom' : prenom ?? null,
               'date_de_naissance' : date_de_naissance,
              'lieu_de_naissance' : lieu_de_naissance,
               'cin' : cin,
              'genre' : genre,
              'contact_personnel': contact_personnel,
              'contact_tutaire' : contact_tutaire,
              'sympathisant' : "${sympathisant == true ? 1 : 0}",
              'axes_id': axesId.toString(),
              'filieres_id': filieres_id.toString(),
              'fonctions_id': fonctions_id.toString(),
              'levels_id': niveau_id.toString(),
              'facebook': facebook,
              'adresse':adresse,
              'date_inscription': date_inscription
            }
    );

    print("---------------> status : ${url}");

    switch(rep.statusCode){
      case 200:
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
