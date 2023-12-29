import 'package:flutter/material.dart';

const color1 = const Color(0xFF1C1C23);
const color2 = Colors.black;
const color3 = const Color(0xFF24D37F);
const color4 = const Color(0xFF353542);
const color5 = const Color(0xFF2656FF);
const color6 = const Color(0xFF666680);
const color7 = const Color(0xFF2A2B34);
const color8 = const Color(0xFF3B3C44);
const color9 = const Color(0xFF959595);

validInput(String val, int min, int max) {
  if (val.length > max) {
    return "ce champ ne peux pas ètre superieur à  $max ";
  }
  if (val.isEmpty) {
    return "Veuillez remplir ce champ SVP";
  }
  if (val.length < min) {
    return "ce champ ne peux pas ètre infèrieur à   $min ";
  }
}
