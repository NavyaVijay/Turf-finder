import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class SizeConfig{
  static double _screenWidth;
  static double _screenHeight;
  static double blockSizeHorizontal;
  static   double blockSizeVertical;

  static double textMultiplier;
  static double imageSizeMultiplier;
  static double heightMultiplier;

  void init(BoxConstraints constraints , Orientation orientation){
      _screenHeight = constraints.maxHeight;
      _screenWidth = constraints.maxWidth;

    blockSizeHorizontal=_screenWidth/100;
    blockSizeVertical=_screenHeight/100;

    textMultiplier=blockSizeVertical;
    heightMultiplier=blockSizeVertical;
    print(blockSizeHorizontal);
    print("width");
    print(blockSizeVertical);
  }



}