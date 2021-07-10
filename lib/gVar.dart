
import 'package:flutter/material.dart';

double sh,sw;
Color ChineseBlack=Color(0xff141414),
    AntiFlashWhite=Color(0xfff2f3f4),
    Tiger=Color(0xfffd6a02),
    Gold=Color(0xfff9a602),
    Rust=Color(0xff8B4000);

gStyle(fs,fw,cr,b){
  return TextStyle(
    fontFamily: "Fujimaru",
    fontSize: fs+0.0,
    fontWeight: fw,
    color: cr,
    decoration: b?TextDecoration.underline:null,
  );
}
setScreenSize(context){
  sh=MediaQuery.of(context).size.height;
  sw=MediaQuery.of(context).size.width;
}