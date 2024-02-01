import 'package:flutter/material.dart';

class MyTextFieldForm extends StatelessWidget {

  final bool edit;
  final String value;
  final String name;
  final Function onChanged;
  final Function validator;
  final IconData iconData;
  final TextInputType textInputType;

  const MyTextFieldForm({Key? key,required this.name, required this.onChanged, required this.validator, required this.iconData, required this.textInputType, required this.edit, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return   TextFormField(
      style: TextStyle(color: Colors.grey),
      initialValue: edit ? value : null,
      decoration: InputDecoration(
        hintText: name,
        prefixIcon: Icon(iconData),
        hintStyle: TextStyle(color: Colors.grey),
        prefixIconColor: Colors.grey,
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
        errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),
      ),
      keyboardType: textInputType,
      onChanged: onChanged(),
      validator: validator(),
    );
  }
}
