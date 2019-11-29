import 'dart:convert';
import 'dart:developer';

import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/my_dialog.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Explicit
  String user, password;
  final formKey = GlobalKey<FormState>();
  //bool statusRemember = false;

  // Method

  // @override
  // void initState() {
  //   super.initState();
  //   //checkStatus();
  // }

  // Future<void> checkStatus() async {
  //   SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  //   String userLogin = sharedPreferences.getString('User');
  //   if (userLogin != null && userLogin.isNotEmpty) {
  //     loadDataLogin(user);
  //   }
  // }

  // Future<void> loadDataLogin(String user) async {
  //   String url = '${MyStyle().urlGetUser}$user';
  //   Response response = await get(url);
  //   var result = json.decode(response.body);

  //   print('1st url = $url');
  //   print('1st = $result');

    // for (var map in result) {
    //   UserAccoutModel userAccoutModel = UserAccoutModel.fromJSON(map);
    //   MaterialPageRoute materialPageRoute =
    //       MaterialPageRoute(builder: (BuildContext context) {
    //     return Store(
    //       userAccoutModel: userAccoutModel,
    //     );
    //   });
    //   Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
    //       (Route<dynamic> route) {
    //     return false;
    //   });
    // }
  // }

  // Widget rememberCheckBox() {
  //   return Container(
  //     width: 250.0,
  //     //color: Colors.grey,
  //     child: CheckboxListTile(
  //       activeColor: MyStyle().textColor,
  //       controlAffinity: ListTileControlAffinity.leading,
  //       title: Text(
  //         'จำรหัสผ่าน',
  //         style: TextStyle(color: MyStyle().textColor),
  //       ),
  //       value: statusRemember,
  //       onChanged: (value) {
  //         setState(() {
  //           statusRemember = value;
  //           print('statusRemember = $statusRemember');
  //         });
  //       },
  //     ),
  //   );
  // }

  Widget showLogo() {
    return Container(
      width: 120.0,
      height: 80.0,
      child: Image.asset('images/logo.png'),
    );
  }

  Widget showAppName() {
    return Text(
      MyStyle().appName,
      style: TextStyle(
        fontSize: MyStyle().h1,
        fontWeight: FontWeight.bold,
        fontStyle: FontStyle.italic,
        color: MyStyle().textColor,
        fontFamily: MyStyle().myFont,
      ),
    );
  }

  Widget userTextForm() {
    return Container(
      width: 230.0,
      child: TextFormField(
        decoration: InputDecoration(
          icon: Icon(
            Icons.account_box,
            size: 36.0,
            color: MyStyle().textColor,
          ),
          labelText: 'User :',
          labelStyle: TextStyle(color: MyStyle().textColor),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณาใส่ไอดี';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          user = value.trim();
        },
      ),
    );
  }

  Widget passwordTextForm() {
    return Container(
      width: 230.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          icon: Icon(
            Icons.lock,
            size: 36.0,
            color: MyStyle().textColor,
          ),
          labelText: 'Password :',
          labelStyle: TextStyle(color: MyStyle().textColor),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'กรุณาใส่รหัสผ่าน';
          } else {
            return null;
          }
        },
        onSaved: (value) {
          password = value.trim();
        },
      ),
    );
  }

  Widget loginButton() {
    return Container(
      width: 250.0,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: MyStyle().textColor,
        child: Text(
          'Login',
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            log('user = $user, password =$password');
            print('user = $user, password =$password');
            checkAuthen();
          }
        },
      ),
    );
  }

  Future<void> checkAuthen() async {
    String url = '${MyStyle().urlGetUser}$user';

    Response response = await get(url);
    var result = json.decode(response.body);
    print('result User = $result');

    if (result.toString() == 'null') {
      normalAlert(context, 'ไม่พบไอดี', 'ไอดี $user ยังไม่ได้ทำการลงทะเบียน ');
    } else {
      for (var map in result) {
        UserAccoutModel userAccoutModel = UserAccoutModel.fromJSON(map);
        String truePass = userAccoutModel.pass;
        print('truePass = $truePass');
        if (password == truePass) {
         // if (statusRemember) {
            print('Login Success');
            saveRemember();
         // }

          MaterialPageRoute materialPageRoute =
              MaterialPageRoute(builder: (BuildContext context) {
            return Store(
              userAccoutModel: userAccoutModel,
            );
          });
          Navigator.of(context).pushAndRemoveUntil(materialPageRoute,
              (Route<dynamic> route) {
            return false;
          });
         } else {
          normalAlert(context, 'รหัสผิด', 'กรุณาลองใหม่อีกครั้ง');
         }
      
      }
    }
  }

  Future<void> saveRemember() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('User', user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [Colors.white, MyStyle().mainColor],
              radius: 1.5,
            ),
          ),
          child: Center(
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(13, 0, 0, 0),
                       child: showLogo(),
                     
                      ),
                      showAppName(),
                    ],
                  ),
                  userTextForm(),
                  passwordTextForm(),
                  SizedBox(
                    height: 8.0,
                  ),
                 // rememberCheckBox(),
                  loginButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
