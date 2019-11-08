import 'package:flutter/material.dart';

class ReportCenter extends StatefulWidget {
  @override
  _ReportCenterState createState() => _ReportCenterState();
}

class _ReportCenterState extends State<ReportCenter> {
  // Explicit

  // Medthod

  void showEditEquipment() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 5.0),
            contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
            title: Text(
              'ค้นหา',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: showEditEquipment1(),
            ),
            actions: <Widget>[
              //okEditButton(),
              //cancelButton(),
            ],
          );
        });
  }

  Widget showEditEquipment1() {
    return Form(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'รหัสวัสดุหรืออุปกรณ์',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่รหัสวัสดุหรืออุปกรณ์';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              //xkeyString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ชื่อวัสดุหรืออุปกรณ์',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ชื่อวัสดุหรืออุปกรณ์';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              //xnameString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        // actions: <Widget>[testLine()],
        backgroundColor: Colors.orange,
        iconTheme: IconTheme.of(context),
        title: Text(
          'ประวัติการทำรายการ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
        ],
      ),
    );
  }
}
