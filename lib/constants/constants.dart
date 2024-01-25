import 'package:flutter/material.dart';

/** ------------- String -----------**/

const baseURL = 'http://192.168.1.107:8000/api';
// const baseURL = 'http://192.168.153.146:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/users';
const axesURL = baseURL + '/axes';
const commentairesURl = baseURL + '/commentaires';
const fonctionsURL = baseURL + '/fonctions';
const filieresURL = baseURL + '/filieres';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';
const avisURL = baseURL + '/avis';
const niveauURL = baseURL + '/niveau';
const messagesURL = baseURL + '/messages';
const membresURL = baseURL + '/membres';

/** -------------- Erreurs -------------- **/
const serverError = 'Erreur du serveur \n Veuillez activez les données mobiles ou connectez-vous au Wi-Fi.';
const unauthorized = 'Accès interdit! Veuillez vous authentifier!';
const somethingWentWrong = 'Quelque chose s\'est mal passé! essaie encore';
const avertissement = "Avertissement";
const pasDeChangement = "Aucun changement n'a été apporté!";
const info = "Info";