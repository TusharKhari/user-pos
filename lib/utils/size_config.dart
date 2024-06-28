import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SizeConfig {
  static double height = 0.0;
  static double width = 0.0;

  static bool isTab = false;

  bool isPortrait = true;

  SizeConfig.init(BuildContext context) {
    height = MediaQuery.of(context).size.height / 100;
    width = MediaQuery.of(context).size.width / 100;

    if (MediaQuery.of(context).orientation == Orientation.portrait) {
      isPortrait = true;
    } else {
      isPortrait = false;
    }

    if (MediaQuery.of(context).size.width > 600) {
      isTab = true;
    } else {
      isTab = false;
    }
  }
  static bool isScreenWidth(double size){
  return  width*100>size? true : false;
  }
  static bool isScreenHeight(double size){
  return  height*100>size? true : false;
  }
}