import 'package:aeutna/constants/fonctions_constant.dart';
import 'package:flutter/material.dart';

class InputText extends StatelessWidget {

  final String hint;
  final Function onChanged;
  final Function validator;
  final IconData iconData;
  final TextInputType textInputType;

  const InputText({Key? key, required this.hint, required this.onChanged, required this.validator, required this.iconData, required this.textInputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 5, left: 8, right: 8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.white
      ),
      child: TextFormField(
        style: style_google.copyWith(color: Colors.blueGrey),
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            prefixIcon: Icon(iconData)
        ),
        onChanged: onChanged(),
        validator: validator(),
      ),
    );
  }
}
