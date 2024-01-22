class Users{

  int? id;
  String? pseudo;
  String? contact;
  String? email;
  String? image;
  String? roles;
  String? adresse;
  int? status;

  Users({
    this.id,
    this.pseudo,
    this.email,
    this.contact,
    this.roles,
    this.image,
    this.adresse,
    this.status
  });

  // function to convert json data to user model
  factory Users.fromJson(Map<String, dynamic> j){
    return Users(
      id: j['id'],
      pseudo: j['pseudo'],
      image: j['image'],
      email: j['email'],
      adresse: j['adresse'],
      contact: j['contact'],
      roles: j['roles'],
      status: j['status']
    );
  }
}