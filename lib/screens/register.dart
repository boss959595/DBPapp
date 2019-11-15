import 'dart:convert';

import 'package:dbpapp/models/user_accout.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
            keyboardType: TextInputType.number,
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
            }
          ),SizedBox(height: 20.0,),Container(width: 230.0,
            child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[okButton(),
                cancelButton(),],),
          )
        ],
      ),
    );
  }

  // Future<void> insertUserAndAccout() async {
  //   //  String xlimitString = limitString;
  //   //  String xtotalString = totalString;
  //   int xlimitString = int.parse(limitString);
  //   int xtotalString = int.parse(totalString);

  //   print(
  //       'object=$keyString,$nameString,$typeString,$groupString,$unitString,$xlimitString,$xtotalString');

  //   String url =
  //       'https://www.androidthai.in.th/boss/addEquipmentBoss.php?isAdd=true&key=$keyString&name=$nameString&type=$typeString&group=$groupString&unit=$unitString&limit=$xlimitString&total=$xtotalString';

  //   Response response = await get(url);
  //   var result = json.decode(response.body);

  //   if (result.toString() == 'true') {
  //     print('insert Equipment Success');
  //     MaterialPageRoute materialPageRoute = MaterialPageRoute(
  //       builder: (BuildContext context) => Store(
  //         userAccoutModel: userAccoutModel,
  //       ),
  //     );
  //     Navigator.of(context).pushAndRemoveUntil(
  //         materialPageRoute, (Route<dynamic> route) => false);
  //   } else {
  //     normalAlert(context, 'ผิดพลาด',
  //         'กรุณา กรอกค่าแจ้งเตือน และ จำนวนของ มากกว่า 1 ขึ้นไป');
  //   }
  // }

  Widget okButton() {
    return OutlineButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(

              'boss = $keyUserString, $nameString, $departmentString, $sectionString, $devisionString, $emailString, $phoneString');
         // insertUserAndAccout()
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
        actions: <Widget>[],
        // actions: <Widget>[testLine()],
        backgroundColor: Colors.orange,
        iconTheme: IconTheme.of(context),
        title: Text(
          'สมัครสมาชิก',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(padding: EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 5.0),
        child: addRegister(),
        
      ),
    );
  }
}
