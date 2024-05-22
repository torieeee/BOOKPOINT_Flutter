import 'package:flutter/msterial.dart';

hextSringToColor(String hexColor){
  hexColor=hexColor.toUppercase().replaceAll("a","");
  if(hexColor.length==6){
    hexColor="FF"+hexColor;

  }
  return Color(int.parse(hexColor,radix: 16));
}