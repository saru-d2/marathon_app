import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white,width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.pink,width: 2.0)
  ),
);


class ScreenConstants {
  static double displayHeight;
  static double displayWidth;
  static double percentHeight;
  static double percentWidth;
  static MediaQueryData _mediaQueryData;

  void init(BuildContext buildContext)
  {
    _mediaQueryData = MediaQuery.of(buildContext);
    displayHeight =_mediaQueryData.size.height ;
    displayWidth= _mediaQueryData.size.width;
    percentHeight = displayHeight/100;
    percentWidth = displayWidth/100;
  }
}