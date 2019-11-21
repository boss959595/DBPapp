import 'package:dbpapp/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_style.dart';

class ReportDetailElectric extends StatefulWidget {
  final ReportElectricModel reportElectricModel;
  ReportDetailElectric({Key key, this.reportElectricModel}) : super(key: key);
  @override
  _ReportDetailElectricState createState() => _ReportDetailElectricState();
}

class _ReportDetailElectricState extends State<ReportDetailElectric> {
  // Explicit
  ReportElectricModel myReportElectricModel;
  String userString;

  // Medthod

  @override
  void initState() {
    super.initState();
    setState(() {
      myReportElectricModel = widget.reportElectricModel;
      findUser();
    });
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
    print('BBB = ${myReportElectricModel.keyRpEe}');
  }

  Widget myDate() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'วันที่ : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.dateRpEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myUser() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ผู้ทำรายการ : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.userRpEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myKey() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'รหัส Motor : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.keyRpEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget mySize() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ขนาด Motor : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.sizeRpEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget mySetup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ลักษณะการติดตั้ง : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.setupRpEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myPlace() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'สถานที่ใช้งาน : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.placeRpEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'สถานะ : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportElectricModel.statusReEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myTotal() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'การทำรายการจาก',
          style: TextStyle(fontSize: 35, color: Colors.lightBlue),
        ),
        Stack(
          children: <Widget>[
            Text(
              '${myReportElectricModel.totalRpEe}',
              style: TextStyle(
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.red,
              ),
            ),
            Text(
              '${myReportElectricModel.totalRpEe}',
              style: TextStyle(
                fontSize: 40,
                color: Colors.yellowAccent,
              ),
            )
          ],
        ),
        Text(
          'EA',
          style: TextStyle(fontSize: 40, color: Colors.lightBlue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        // actions: <Widget>[testLine()],
        backgroundColor: Colors.yellowAccent,
        iconTheme: IconTheme.of(context),
        title: Text(
          'รายละเอียดการทำรายการ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                myDate(),
                Divider(),
                myKey(),
                Divider(),
                myUser(),
                Divider(),
                mySize(),
                Divider(),
                mySetup(),
                Divider(),
                myPlace(),
                Divider(),
                myStatus(),
                Divider(),
                myTotal(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
