class Numero{

  String? contact_personnel;

  Numero({
    this.contact_personnel,
  });

  // function to convert json data to avis model
  factory Numero.fromJson(Map<String, dynamic> m){
    return Numero(
      contact_personnel: m['contact_personnel'],
    );
  }
}