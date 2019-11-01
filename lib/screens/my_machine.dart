import 'package:flutter/material.dart';

import 'my_style.dart';

class MyMachine extends StatefulWidget {
  @override
  _MyMachineState createState() => _MyMachineState();
}

class _MyMachineState extends State<MyMachine> {

  // Explicil
  List<String> iconMaterial = [
    'images/matcenter.png',
    'images/matelec.png',
    'images/matmachine.png',
  ];

  List<String> iconNotify = [
    'images/worn1.png',
    'images/worn2.png',
    'images/worn3.png',
  ];

  List<String> iconHistory = [
    'images/his1.png',
    'images/his2.png',
    'images/his3.png',
  ];


   int indexMaterial = 2;

  // Method

   Widget cardMenu1() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          width: 80.0,
          height: 80.0,
          child: Image.asset(iconMaterial[indexMaterial]),
        ),
        title: Text(
          'วัสดุ และ อุปกรณ์',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ),
    );
  }

  Widget cardMenu2() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          width: 80.0,
          height: 80.0,
          child: Image.asset(iconNotify[indexMaterial]),
        ),
        title: Text(
          'แจ้งเตือน',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ),
    );
  }

  Widget cardMenu3() {
    return Card(
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8.0),
          width: 80.0,
          height: 80.0,
          child: Image.asset(iconHistory[indexMaterial]),
        ),
        title: Text(
          'ประวัติการทำรายการ',
          style: TextStyle(
            fontSize: MyStyle().h2,
          ),
        ),
      ),
    );
  }

   Widget content() {
    return Container(
      padding: EdgeInsets.only(
        left: 35.0,
        right: 35.0,
        top: 100.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          cardMenu1(),
          SizedBox(
            height: 15.0,
          ),
          cardMenu2(),
          SizedBox(
            height: 15.0,
          ),
          cardMenu3(),
          SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [Colors.white, Colors.brown],
          radius: 1.8,center: Alignment.topCenter,
        ),
      ),
      child: Column(
        children: <Widget>[
          content(),
        ],
      ),
    );
  }
}