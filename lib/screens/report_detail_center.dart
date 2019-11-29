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

   Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
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
            '${myReportModel.dateEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'กลุ่ม : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportModel.groupRe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myType() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ประเภท : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportModel.typeRe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อ : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportModel.nameRe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),maxLines: 2,
          ),
        ),
      ],
    );
  }

  Widget myStatus() {
    return Row(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'สถานะ : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportModel.statusRe}',
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
            '${myReportModel.userRe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myNo() {
    return Row(
      children: <Widget>[
        Text(
          'No. ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportModel.noRe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myBecause() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'สาเหตุ/การชำรุด : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myReportModel.becauseRe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myStatusAndMyNo() {
    return new Column(mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        myStatus(),
        myNo(),
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
                myStatusAndMyNo(),
                // myStatus(),
                // Divider(),
                // myNo(),
                Divider(),
                myBecause(),
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
