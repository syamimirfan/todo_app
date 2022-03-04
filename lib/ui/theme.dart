import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

//define the COLORS
const Color bluishClr = Color(0xff4e68e8); //ada bug between this in sdk version  in primaryColor and primarySwatch
const Color yellowClr = Color(0xFFFFB746);
const Color pinkClr = Color(0xFFff4667);
const Color white = Colors.white;

//set the COLORS
const  primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF272525);
Color darkHeaderClr = Color(0xFF424242);


class Themes  {

  // themedata can change the design in text color, bar, button, etc
  // themedata cna change dark theme
  static final light =  ThemeData(
     backgroundColor: Colors.white,
      primaryColor: bluishClr,
        brightness: Brightness.light
      //swap dark mode cannot do in primary swatch
      );

  //darkTheme to use themeData to change the dark theme
  static final dark = ThemeData(
      backgroundColor:darkGreyClr,
      primaryColor: darkGreyClr,
      brightness: Brightness.dark
      );

}

//getters method
TextStyle get subHeadingStyle {
  return GoogleFonts.poppins (
    textStyle: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode?Colors.grey[400]:Colors.grey
    )
  );
}

TextStyle get headingStyle {
  return GoogleFonts.poppins (
      textStyle: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get titleStyle {
  return GoogleFonts.poppins (
      textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.white:Colors.black
      )
  );
}

TextStyle get subTitleStyle {
  return GoogleFonts.poppins (
      textStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Get.isDarkMode?Colors.grey[100]:Colors.grey[700]
      )
  );
}