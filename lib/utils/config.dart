import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';


class Config {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

//width and height initialization
  static void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;
  }

  static get widthSize {
    return screenWidth;
  }

  static get heightSize {
    return screenHeight;
  }

//defining spacing height
  static const spaceSmall = SizedBox(
    height: 25,
  );
  static SizedBox get spaceMedium {
    return SizedBox(
      height: screenHeight! * 0.05,
    );
  }

  static SizedBox get spaceBig {
    return SizedBox(
      height: screenHeight! * 0.08,
    );
  }

  //textform fiel folder
  static const outlinedBorder =
      OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8)));

  static const focusBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.greenAccent,
      ));

  static const errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: Colors.red,
      ));

  static const primaryColor = Colors.greenAccent;
}
