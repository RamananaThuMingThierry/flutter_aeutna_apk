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
  String? contact_tuteur,
  bool? sympathisant,
  int? axesId,
  int? sectionsId,
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

    print(
        "url : $url \n"
            "numero carte : $numero_carte \n"
            "sympathisant : $sympathisant \n"
            "cin : $cin \n"
            "nom : $nom \n"
            "prenom : $prenom \n"
            "date_de_naissaince : $date_de_naissance \n"
            "lieu de naissance : $lieu_de_naissance \n"
            "adresse : $adresse \n"
            "contact personnel : $contact_personnel \n"
            "contact tuteur : $contact_tuteur"
            "sectionsId : $sectionsId \n"
            "filiereId : $filieres_id \n"
            "niveauId : $niveau_id \n"
            "fonctionId : $fonctions_id \n"
            "axesId : $axesId \n"
            "date_inscription : $date_inscription \n"
            "image : $image \n"
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
              'prenom' : prenom.toString(),
              'cin' : cin.toString(),
              'date_de_naissance' : date_de_naissance.toString(),
              'lieu_de_naissance' : lieu_de_naissance,
              'genre' : genre,
              'contact_personnel' : contact_personnel,
              'contact_tuteur' : contact_tuteur,
               'sympathisant' : "${sympathisant == true ? 1 : 0}",
              'fonctions_id' : fonctions_id.toString(),
              'axes_id' : "${axesId == 0 ? null : axesId}",
               'levels_id' : niveau_id.toString(),
              'sections_id' : sectionsId.toString(),
              'facebook' : facebook,
              'adresse' : adresse,
              'filieres_id' : filieres_id.toString(),
              'date_inscription' : date_inscription.toString(),
            }
    );

    print("---------------> status : ${rep.statusCode} : ${rep.body}");

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

/*** ------------- Recherche un membre ---------------- **/
Future<ApiResponse> searchMembres(String? value) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_search/${value}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    print("----------- ${jsonDecode(rep.body)['membres']}");

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/*** ------------- Recherche un membre ---------------- **/
Future<ApiResponse> searchMembresAxes(String? value, int? axesId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_search_axes/${value}/${axesId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Filtre par les membres par axes ------ **/
Future<ApiResponse> filtreMembresParAxes(int? axesId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_filtreAxesMembre/${axesId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/*** ------------- Recherche un membre filtre par niveau ---------------- **/
Future<ApiResponse> searchMembresNiveau(String? value, int? niveauId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_search_niveau/${value}/${niveauId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Filtre par les membres par niveau ------ **/
Future<ApiResponse> filtreMembresParNiveau(int? niveauId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_filtreNiveauMembre/${niveauId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/*** ------------- Recherche un membre filtre par filière ---------------- **/
Future<ApiResponse> searchMembresFiliere(String? value, int? filiereId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_search_filiere/${value}/${filiereId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Filtre par les membres par filière ------ **/
Future<ApiResponse> filtreMembresParFiliere(int? filiereId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_filtreFiliereMembre/${filiereId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/*** ------------- Recherche un membre filtre par fonction ---------------- **/
Future<ApiResponse> searchMembresFonction(String? value, int? fonctionId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_search_fonction/${value}/${fonctionId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Filtre par les membres par fonction ------ **/
Future<ApiResponse> filtreMembresParFonction(int? fonctionId) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_filtreFonctionMembre/${fonctionId}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Filtre par les membres par fonction ------ **/
Future<ApiResponse> filtreAll(int? fonctionId, int? filiereId, int? niveauId, int? sectionId, int? axesId, String? genre, bool? sympathisant ) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_filtreAll/${fonctionId}/${filiereId}/${niveauId}/${sectionId}/${axesId}/${genre}/${sympathisant == true ? 1 : 0}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Recherche les membres par FiltreAll ------ **/
Future<ApiResponse> searchfiltreAll(String? value,int? fonctionId, int? filiereId, int? niveauId, int? sectionId, int? axesId, String? genre, bool? sympathisant ) async{

  ApiResponse apiResponse = ApiResponse();
  try{

    String token = await getToken();
    var url = Uri.parse("${membresURL}_searchInfiltreAll/${value}/${fonctionId}/${filiereId}/${niveauId}/${sectionId}/${axesId}/${genre}/${sympathisant == true ? 1 : 0}");

    final rep = await http.get(url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
        apiResponse.data = jsonDecode(rep.body)['membres'];
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

/** --------------- Modifier un Membre ----------------- **/
Future<ApiResponse> updateMembre({
  int? membreIdUpdate,
  String? image,
  int? numero_carte,
  String? nom,
  String? prenom,
  String? date_de_naissance,
  String? lieu_de_naissance,
  String? cin,
  String? genre,
  String? contact_personnel,
  String? contact_tuteur,
  bool? sympathisant,
  int? axesId,
  int? sectionsId,
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

    var url = Uri.parse("$membresURL/$membreIdUpdate");

    print(
          "url : $url \n"
          "numero carte : $numero_carte \n"
          "sympathisant : $sympathisant \n"
          "cin : $cin \n"
          "nom : $nom \n"
          "prenom : $prenom \n"
          "date_de_naissaince : $date_de_naissance \n"
          "lieu de naissance : $lieu_de_naissance \n"
          "adresse : $adresse \n"
          "contact personnel : $contact_personnel \n"
          "contact tuteur : $contact_tuteur"
          "sectionsId : $sectionsId \n"
          "filiereId : $filieres_id \n"
          "fonctionId : $fonctions_id \n"
          "axesId : $axesId \n"
          "date_inscription : $date_inscription \n"
          "image : $image \n"
       );

    final rep = await http.put(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        },
        body: {
          'image' : image,
          'numero_carte' : numero_carte.toString(),
          'nom' : nom,
          'prenom' : prenom,
          'date_de_naissance' : date_de_naissance,
          'lieu_de_naissance' : lieu_de_naissance,
          'adresse' : adresse,
          'cin' : cin.toString(),
          'contact_personnel' : contact_personnel,
          'contact_tuteur' : contact_tuteur,
          'facebook' : facebook,
          'genre' : genre,
          'fonctions_id' : fonctions_id.toString(),
          'filieres_id' : filieres_id.toString(),
          'levels_id' : niveau_id.toString(),
          'axes_id' : axesId == 0 ? null : axesId.toString(),
          'sections_id' : sectionsId.toString(),
          'sympathisant' : "${sympathisant! ? 1 : 0}",
          'date_inscription' : date_inscription,
        }
    );

    print("---------------> status : ${rep.statusCode} : ${rep.body}");

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

/** --------------- Statistiques ----------------- **/
Future<ApiResponse> statistiquesMembres() async{
  ApiResponse apiResponse = ApiResponse();
  try{
    String token = await getToken();
    var url = Uri.parse('${membresURL}_statistiques');
    final rep = await http.get(
        url,
        headers: {
          'Accept': 'application/json',
          'Authorization' : 'Bearer $token'
        }
    );

    switch(rep.statusCode){
      case 200:
      // Convertir la réponse JSON en une carte
        Map<String, dynamic> jsonData = json.decode(rep.body);

        // Créer une liste pour stocker les données
        List<Map<String, int>> dataList = [];

        // Itérer sur les entrées de la carte et les ajouter à la liste
        jsonData.forEach((key, value) {
          dataList.add({key: value as int});
        });

        apiResponse.data = dataList;
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
