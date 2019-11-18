import 'dart:convert';

import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_dialog.dart';
import 'my_style.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
//  Explicil
  String userString,
      levelString = '',
      keyUserString,
      nameString,
      departmentString,
      sectionString,
      devisionString,
      emailString,
      phoneString;
  UserAccoutModel userAccoutModel;
  final formKey = GlobalKey<FormState>();

// Model

  @override
  void initState() {
    super.initState();
    setState(() {
      findUser();
    });
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
    findLevel();
  }

  Future findLevel() async {
    String url = '${MyStyle().urlGetUser}$userString';
    Response response = await get(url);
    var result = json.decode(response.body);
    print(result);
    for (var map in result) {
      userAccoutModel = UserAccoutModel.fromJSON(map);
      setState(() {
        levelString = userAccoutModel.level;
      });
    }
  }

  Widget addRegister() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'รหัสพนักงาน',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่รหัสพนักงาน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              keyUserString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ชื่อ-นามสกุล',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ ชื่อ-นามสกุล';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              nameString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'แผนก',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onSaved: (value) {
              departmentString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ส่วน',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onSaved: (value) {
              sectionString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ฝ่าย',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ ฝ่าย';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              devisionString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onSaved: (value) {
              emailString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'เบอร์ติดต่อ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            onSaved: (value) {
              phoneString = value.trim();
            },
          ),
          SizedBox(
            height: 20.0,
          ),
          Container(
            width: 230.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                okButton(),
                cancelButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> insertUserAndAccout() async {
    // print(
    //     'object VVV=$keyUserString, $nameString, $departmentString, $sectionString, $devisionString, $emailString, $phoneString');

    String url =
        'https://www.androidthai.in.th/boss/addUserBoss.php?isAdd=true&employee_id=$keyUserString&name=$nameString&department=$departmentString&section=$sectionString&division=$devisionString&email=$emailString&phone=$phoneString';

    Response response = await get(url);
    var result = json.decode(response.body);

    String url2 =
        'https://www.androidthai.in.th/boss/addAccoutBoss.php?isAdd=true&user=$keyUserString&pass=1234';

    Response response2 = await get(url2);
    var result2 = json.decode(response2.body);

    if (result.toString() == 'true' && result2.toString() == 'true') {
      print('insert Equipment Success');
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (BuildContext context) => Store(
          userAccoutModel: userAccoutModel,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    } else {
      normalAlert(context, 'ผิดพลาด', 'กรุณา แจ้งผู้ดูแลระบบ');
    }
  }

  Widget okButton() {
    return OutlineButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'boss = $keyUserString, $nameString, $departmentString, $sectionString, $devisionString, $emailString, $phoneString');
          insertUserAndAccout();
          Navigator.of(context).pop();
        }
      },
      borderSide: BorderSide(color: Colors.lightGreenAccent),
    );
  }

  Widget cancelButton() {
    return OutlineButton(
      child: Text('ยกเลิก'),
      onPressed: () {
        Navigator.of(context).pop();
      },
      borderSide: BorderSide(
        color: Colors.red[300],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: IconTheme.of(context),
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 5.0),
        child: addRegister(),
      ),
    );
  }
}
