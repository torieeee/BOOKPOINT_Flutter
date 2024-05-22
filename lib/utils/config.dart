import 'package:flutter/material.dart';

class Config{
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

//width and height initialization
  void init(BuildContext context){
    mediaQueryData=MediaQueryData.of(context);
    screenWidth=mediaQueryData!.size.width;
    screenHeight=mediaQueryData!.size.height;

  }
  static get widthSize{
    return screenWidth;
  }
  static get heightSize{
    return screenHeight;
  }

//defining spacing height
  static const spaceSmall=SizedBox(height:25,);
  static const spaceMedium=SizedBox(height:screenHeight! * 0.05,);
  static const spaceBig=SizedBox(height: screenHeight!* 0.08,);

  //textform fiel folder
  static const OutlinedBorder=OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8))
  )
}