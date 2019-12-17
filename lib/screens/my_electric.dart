import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/alertLimit_electric.dart';
import 'package:dbpapp/screens/search_electric.dart';
import 'package:flutter/material.dart';
import 'my_style.dart';
import 'report_electric.dart';

class MyElectric extends StatefulWidget {
  final UserAccoutModel userAccoutModel;
  MyElectric({Key key, this.userAccoutModel}) : super(key: key);
  @override
  _MyElectricState createState() => _MyElectricState();
}

class _MyElectricState extends State<MyElectric> {
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

  int indexMaterial = 1;

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
          'รายการ มอเตอร์',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
        onTap: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => SearchElectric());
          Navigator.of(context).push(materialPageRoute);
        },
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
        onTap: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => AlertLimitElectric());
          Navigator.of(context).push(materialPageRoute);
        },
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
        onTap: () {
          MaterialPageRoute materialPageRoute = MaterialPageRoute(
              builder: (BuildContext context) => ReportElectric());
          Navigator.of(context).push(materialPageRoute);
        },
      ),
    );
  }

  Widget content() {
    return Container(
      padding: EdgeInsets.only(
        left: 30.0,
        right: 30.0,
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
          colors: [Colors.white, Colors.yellowAccent],
          radius: 1.8,
          center: Alignment.topCenter,
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
