import 'package:flutter/material.dart';

class MyStyle {
  double h1 = 30.0, h2 = 18.0;
  String appName = 'Engineering Store';
  String myFont = 'Charm';

  String urlGetUser =
      'https://iot-en.me/api/getUserWhereUserBoss.php?isAdd=true&User=';
      

  String urlGetName =
      'https://iot-en.me/api/getNameWhereUserBoss.php?isAdd=true&User=';
      

  // Color textColor = Color.fromARGB(255, 206, 23, 30);
  Color textColor = Colors.orange.shade900;
  Color mainColor = Color.fromARGB(255, 253, 188, 17);
  Color appBarCenter = Colors.orange;
  Color appBarElectric = Colors.yellowAccent;
  Color appBarMachine = Colors.brown;
  

  MyStyle();
}
