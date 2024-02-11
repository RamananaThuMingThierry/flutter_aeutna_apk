import 'package:aeutna/models/user.dart';

class Membres{

  int? id;
  String? image;
  int? numero_carte;
  String? nom;
  String? prenom;
  String? date_de_naissance;
  String? lieu_de_naissance;
  String? genre;
  String? cin;
  String? facebook;
  String? contact_personnel;
  String? contact_tuteur;
  String? adresse;
  String? date_inscription;
  int? fonctions_id;
  int? filieres_id;
  int? levels_id;
  int? axes_id;
  int? sections_id;
  int? symapthisant;
  int? lien_membre_id;
  User? user;

  Membres({
    this.id,
    this.image,
    this.numero_carte,
    this.nom,
    this.prenom,
    this.date_de_naissance,
    this.lieu_de_naissance,
    this.genre,
    this.adresse,
    this.cin,
    this.user,
    this.facebook,
    this.fonctions_id,
    this.filieres_id,
    this.levels_id,
    this.axes_id,
    this.sections_id,
    this.contact_personnel,
    this.contact_tuteur,
    this.symapthisant,
    this.date_inscription,
    this.lien_membre_id
  });

  // function to convert json data to avis model
  factory Membres.fromJson(Map<String, dynamic> m){
    return Membres(
      id: m['id'],
      numero_carte: m['numero_carte'],
      nom: m['nom'],
      prenom: m['prenom'],
      date_de_naissance: m['date_de_naissance'],
      lieu_de_naissance: m['lieu_de_naissance'],
      cin:m['cin'],
      fonctions_id: m['fonctions_id'],
      filieres_id: m['filieres_id'],
      levels_id: m['levels_id'],
      axes_id: m['axes_id'],
      facebook:m['facebook'],
      genre: m['genre'],
      adresse: m['adresse'],
      contact_personnel: m['contact_personnel'],
      contact_tuteur: m['contact_tuteur'],
      image: m['image'],
      sections_id: m['sections_id'],
      symapthisant: m['sympathisant'],
      date_inscription: m['date_inscription'],
      lien_membre_id: m['lien_membre_id'],
      user: User(
        id: m['users']['id'],
        pseudo: m['users']['pseudo'],
        image: m['users']['image'],
        email: m['users']['email']
      ),
    );
  }
}