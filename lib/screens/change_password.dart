import 'dart:convert';

import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/my_dialog.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_style.dart';

class ChangePassword extends StatefulWidget {
  final UserAccoutModel userAccoutModel;
  ChangePassword({Key key, this.userAccoutModel}) : super(key: key);
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  // Explicit
  String userString, levelString = '', passwordString, passwordString2;
  UserAccoutModel myUserAccoutModel;
  final formKey = GlobalKey<FormState>();

  // Model

  @override
  void initState() {
    super.initState();
    setState(() {
      myUserAccoutModel = widget.userAccoutModel;
      findUser();
    });
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
    findId();
  }

  Future findId() async {
    String url = '${MyStyle().urlGetUser}$userString';
    Response response = await get(url);
    var result = json.decode(response.body);
    print(result);
    for (var map in result) {
      myUserAccoutModel = UserAccoutModel.fromJSON(map);
      setState(
        () {
          levelString = myUserAccoutModel.level;
        },
      );
    }
  }

  Widget changePassword() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'กรอกรหัสผ่านที่ต้องการเปลี่ยน',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่รหัสที่ต้องการเปลี่ยน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              passwordString = value.trim();
            },
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ยืนยันรหัสผ่านอีกครั้ง',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'รหัสสองช่องไม่ตรงกัน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              passwordString2 = value.trim();
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

  Future<void> editPassword() async {
    int idAccout = int.parse(myUserAccoutModel.idAcc);
    // print('PPP O = $idAccout $passwordString $passwordString2');
    if (passwordString == passwordString2) {
      String url =
          'https://iot-en.me/api/updatePasswordWhereIdboss.php?isAdd=true&id_acc=$idAccout&pass=$passwordString';

      Response response = await get(url);
      var result = jsonDecode(response.body);

      if (result.toString() == 'true') {
        print('Edit Password Success');
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (BuildContext context) => Store(
            userAccoutModel: myUserAccoutModel,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      } else {
        return null;
      }
    }
  }

  Widget okButton() {
    return OutlineButton(
      child: Text('ยืนยัน'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('PPP = $passwordString, $passwordString2');
          if (passwordString == passwordString2) {
            editPassword();
            Navigator.of(context).pop();
          } else {
            normalAlert(context, 'ผิดพลาด', 'การยืนยันรหัสผ่านไม่ตรงกัน');
          }
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
          'เปลี่ยนรหัสเข้าใช้งาน',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(25.0, 40.0, 25.0, 5.0),
        child: changePassword(),
      ),
    );
  }
}
