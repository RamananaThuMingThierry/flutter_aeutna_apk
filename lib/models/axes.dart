import 'package:aeutna/models/user.dart';

class Axes{

  int? id;
  String? nom_axes;

  Axes({
    this.id,
    this.nom_axes,
  });

  // function to convert json data to axes model
  factory Axes.fromJson(Map<String, dynamic> a){
    return Axes(
      id: a['id'],
      nom_axes: a['nom_axes'],
    );
  }
}