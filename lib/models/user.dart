class Users{

  int? id;
  String? pseudo;
  String? contact;
  String? email;
  String? image;
  String? roles;
  String? adresse;
  String? status;
  String? token;

  Users({
    this.id,
    this.pseudo,
    this.email,
    this.contact,
    this.roles,
    this.image,
    this.adresse,
    this.status,
    this.token
  });

  // function to convert json data to user model
  factory  Users.fromJson(Map<String, dynamic> j){
    return Users(
      id: j['user']['id'],
      pseudo: j['user']['pseudo'],
      image: j['user']['image'],
      contact: j['user']['contact'],
      adresse: j['user']['adresse'],
      email: j['user']['email'],
      roles: j['user']['roles'],
      status: j['user']['status'],
      token: j['token'],
    );
  }
}