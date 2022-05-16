import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyConstant {
  //Gernarol
  static String appName = 'NongPang Shopping';
  // Route
  static String routeAuthen = '/authen';
  static String routeCreateAccount = '/createAccount';
  static String routeBuyerService = '/buyerService';
  static String routeSellerService = '/sellerService';
  static String routeRiderService = '/riderService';
  // Images
  static String image1 = 'images/image1.png';
  static String image2 = 'images/image2.png';
  static String image3 = 'images/image3.png';
  static String image4 = 'images/image4.png';
  static String image5 = 'images/image5.png';
  // Colors
  static Color primary = Color(0xff212121);
  static Color dark = Color(0xff000000);
  static Color light = Color(0xff484848);
  // TextStyle
  TextStyle h1Style() =>
      TextStyle(fontSize: 24, color: dark, fontWeight: FontWeight.bold);
  TextStyle h2Style() =>
      TextStyle(fontSize: 18, color: dark, fontWeight: FontWeight.w700);
  TextStyle h3Style() =>
      TextStyle(fontSize: 14, color: dark, fontWeight: FontWeight.normal);
  //ButtonStyle
  ButtonStyle myButtonStyle() => ElevatedButton.styleFrom(
        primary: MyConstant.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      );
}
