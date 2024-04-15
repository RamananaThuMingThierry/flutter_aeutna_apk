import 'package:flutter/material.dart';

/** ------------- String -----------**/
const baseURL = 'http://192.168.1.107:8000/api';
// const baseURL = 'http://192.168.88.76:8000/api';
// const baseURL = 'https://aeutna.masovia-madagascar.com/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/users';
const axesURL = baseURL + '/axes';
const sectionsURL = baseURL + '/sections';
const fonctionsURL = baseURL + '/fonctions';
const filieresURL = baseURL + '/filieres';
const commentsURL = baseURL + '/comments';
const niveauURL = baseURL + '/niveau';
const membresURL = baseURL + '/membres';
const changer_mot_de_passe = baseURL + '/profiles/changer_mot_de_passe';
const forgetpasswordURL = baseURL + '/forget-password';
const comfirmationURL = baseURL + '/comfirmation';
const reinitialiser_mot_de_passeURL = baseURL + '/reinitialiser_mot_de_passe';

/** -------------- Erreurs -------------- **/
const serverError = 'Erreur du serveur \n Veuillez activez les données mobiles ou connectez-vous au Wi-Fi.';
const unauthorized = 'Accès interdit! Veuillez vous authentifier!';
const somethingWentWrong = 'Quelque chose s\'est mal passé! essaie encore';
const avertissement = "Avertissement";
const pasDeChangement = "Aucun changement n'a été apporté!";
const info = "Info";