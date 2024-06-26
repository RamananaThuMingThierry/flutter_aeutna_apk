import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class PasswordFieldForm extends StatelessWidget {

  final String name;
  final bool visibility;
  final Function validator;
  final Function onChanged;
  final Function onTap;

  const PasswordFieldForm({Key? key, required this.visibility, required this.validator, required this.name, required this.onTap, required this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return    TextFormField(
      style: style_google.copyWith(color: Colors.grey),
      decoration: InputDecoration(
        hintText: name,
        suffixIconColor: Colors.grey,
        enabledBorder : UnderlineInputBorder(
          borderSide: BorderSide(
              color: Colors.grey
          ),
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey,
            )
        ),
        prefixIcon: Icon(Icons.vpn_key, color: Colors.grey,),
        suffixIcon: GestureDetector(
          onTap: onTap(),
          child: visibility ? Icon(Icons.visibility_outlined, color: Colors.grey,) : Icon(Icons.visibility_off_outlined),
        ),
        hintStyle: style_google.copyWith(color: Colors.grey),
      ),
      obscureText: visibility,
      keyboardType: TextInputType.text,
      onChanged: onChanged(),
      validator: validator(),
    );
  }
}
