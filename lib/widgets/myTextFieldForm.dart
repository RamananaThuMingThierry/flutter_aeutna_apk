import 'package:flutter/material.dart';

class MyTextFieldForm extends StatelessWidget {

  final bool edit;
  final String value;
  final String name;
  final Function onChanged;
  final Function validator;
  final IconData iconData;
  final TextInputType textInputType;
  final TextEditingController nom_controller;

  const MyTextFieldForm({Key? key,required this.nom_controller, required this.name, required this.onChanged, required this.validator, required this.iconData, required this.textInputType, required this.edit, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      controller: nom_controller,
      style: TextStyle(color: Colors.blueGrey),
      initialValue: edit ? value : null,
      decoration: InputDecoration(
        hintText: name,
        suffixIcon: Icon(iconData),
        hintStyle: TextStyle(color: Colors.blueGrey),
        suffixIconColor: Colors.grey,
        enabledBorder : UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey,
            ),
        ),
      ),
      keyboardType: textInputType,
      onChanged: onChanged(),
      validator: validator(),
    );
  }
}
