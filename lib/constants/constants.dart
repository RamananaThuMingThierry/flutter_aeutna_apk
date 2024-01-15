import 'package:flutter/material.dart';

/** ------------- String -----------**/

const baseURL = 'http://192.168.1.107:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const postsURL = baseURL + '/posts';
const commentsURL = baseURL + '/comments';

/** -------------- Erreurs -------------- **/
const serverError = 'Erreur du serveur';
const unauthorized = 'Accès interdit! Veuillez vous authentifier!';
const somethingWentWrong = 'Quelque chose s\'est mal passé! essaie encore';