import 'package:dbpapp/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_style.dart';

class ShowReportDetailCenter extends StatefulWidget {
  final ReportModel reportModel;
  ShowReportDetailCenter({Key key, this.reportModel}) : super(key: key);
  @override
  _ShowReportDetailCenterState createState() => _ShowReportDetailCenterState();
}

class _ShowReportDetailCenterState extends State<ShowReportDetailCenter> {
  // Explicit
  ReportModel myReportModel;
  String userString;

  //Medthod

  @override
  void initState() {
    super.initState();
    setState(() {
      myReportModel = widget.reportModel;
      findUser();
    });
  }

  Widget myDate() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'วันที่ :  ${myReportModel.dateEe}',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ],
    );
  }

  Widget myGroup() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'กลุ่ม :  ${myReportModel.groupRe}',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ],
    );
  }

  Widget myType() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ประเภท :  ${myReportModel.typeRe}',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ],
    );
  }

  Widget myName() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อวัสดุ/อุปกรณ์ :  ${myReportModel.nameRe}',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ],
    );
  }

  Widget myUser() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อผู้ทำรายการ :  ${myReportModel.userRe}',
          style: TextStyle(fontSize: MyStyle().h2),
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
              '${myReportModel.totalRe}',
              style: TextStyle(
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.red,
              ),
            ),
            Text(
              '${myReportModel.totalRe}',
              style: TextStyle(
                fontSize: 40,
                color: Colors.yellowAccent,
              ),
            )
          ],
        ),
        Text(
          '${myReportModel.unitRe}',
          style: TextStyle(fontSize: 40, color: Colors.lightBlue),
        ),
      ],
    );
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[],
        // actions: <Widget>[testLine()],
        backgroundColor: Colors.orange,
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
                myUser(),
                Divider(),
                myType(),
                Divider(),
                myGroup(),
                Divider(),
                myName(),
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
