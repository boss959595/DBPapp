import 'dart:convert';

import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/models/user_model.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class Store extends StatefulWidget {
  final UserAccoutModel userAccoutModel;
  Store({Key key, this.userAccoutModel}) : super(key: key);

  @override
  _StoreState createState() => _StoreState();
}

class _StoreState extends State<Store> {
  // Explicit
  UserAccoutModel _userAccoutModel;
  String loginString ='';
  UserModel userModel;

  // Method
  @override
  void initState(){
    super.initState();
    _userAccoutModel = widget.userAccoutModel; 
      print('userLogin =${_userAccoutModel.user}');
      findNameLogin();
  }

  Future<void> findNameLogin()async{
    String url ='${MyStyle().urlGetName}${_userAccoutModel.user}';
    Response response = await get(url);
    var result = jsonDecode(response.body);
    print('result = $result');
    for (var map in result) {
      setState(() {
       userModel = UserModel.fromJson(map);
      loginString = userModel.name;
      print('loginString = $loginString'); 
      });
    }
    }

  Widget showLogin() {
    return Text('ผู้ใช้ $loginString');
  }

  Widget showAvatar() {
    return Container(
      width: 100.0,
      height: 100.0,
      child: Image.asset('images/avatar.png'),
    );
  }

  Widget showHeadDrawer() {
    return DrawerHeader(
      child: Column(
        children: <Widget>[
          showAvatar(),
          showLogin(),
        ],
      ),
    );
  }

  Widget showDrawer() {
    return Drawer(
      child: ListView(
        children: <Widget>[
          showHeadDrawer(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Store'),
      ),
      body: Text('body'),
      drawer: showDrawer(),
    );
  }
}
