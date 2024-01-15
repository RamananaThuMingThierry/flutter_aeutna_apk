class User{

  int? id;
  String? pseudo;
  String? contact;
  String? email;
  String? image;
  String? roles;
  String? status;
  String? token;

  User({
    this.id,
    this.pseudo,
    this.email,
    this.contact,
    this.roles,
    this.image,
    this.status,
    this.token
  });

  // function to convert json data to user model
  factory  User.fromJson(Map<String, dynamic> j){
    return User(
      id: j['user']['id'],
      pseudo: j['user']['pseudo'],
      email: j['user']['email'],
      contact: j['user']['contact'],
      image: j['user']['image'],
      roles: j['user']['roles'],
      status: j['user']['status'],
      token: j['token'],
    );
  }
}