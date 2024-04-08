class User{

  int? id;
  String? pseudo;
  String? contact;
  String? email;
  String? image;
  String? roles;
  String? adresse;
  int? status;
  String? token;

  User({
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
  factory User.fromJson(Map<String, dynamic> j){
    return User(
      id: j['user']['id'],
      pseudo: j['user']['pseudo'],
      image: j['user']['image'],
      email: j['user']['email'],
      adresse: j['user']['adresse'],
      contact: j['user']['contact'],
      roles: j['user']['roles'],
      status: j['user']['status'],
      token: j['token'],
    );
  }
}