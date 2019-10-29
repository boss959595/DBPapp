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
  String loginString = '';
  UserModel userModel;

  // Method
  void closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _userAccoutModel = widget.userAccoutModel;
    print('userLogin =${_userAccoutModel.user}');
    findNameLogin();
  }

  Widget menuCenterStore() {
    return ListTile(
      leading: Icon(
        Icons.build,
        size: 36.0,
        color: Colors.orange[600],
      ),
      title: Text('คลังกลาง'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuElectricStore() {
    return ListTile(
      leading: Icon(
        Icons.flash_on,
        size: 36.0,
        color: Colors.yellow[600],
      ),
      title: Text('คลังไฟฟ้า'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuMachineStore() {
    return ListTile(
      leading: Icon(
        Icons.settings_applications,
        size: 36.0,
        color: Colors.brown[600],
      ),
      title: Text('คลังเครื่องกล'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuChangePassStore() {
    return ListTile(
      leading: Icon(
        Icons.lock,
        size: 36.0,
        color: Colors.green[600],
      ),
      title: Text('เปลี่ยนรหัส'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Widget menuLogOutStore() {
    return ListTile(
      leading: Icon(
        Icons.exit_to_app,
        size: 36.0,
        color: Colors.deepOrange[600],
      ),
      title: Text('ออกระบบ'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        closeDrawer();
      },
    );
  }

  Future<void> findNameLogin() async {
    String url = '${MyStyle().urlGetName}${_userAccoutModel.user}';
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'ผู้ใช้ $loginString',
          style: TextStyle(
            color: Colors.orange,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget showAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 100.0,
          height: 100.0,
          child: Image.asset('images/avatar.png'),
        ),
      ],
    );
  }

  Widget showHeadDrawer() {
    return DrawerHeader(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/bg1.jpg'),
          fit: BoxFit.fill,
        ),
      ),
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
          menuCenterStore(),
          Divider(),
          menuElectricStore(),
          Divider(),
          menuMachineStore(),
          Divider(),
          menuChangePassStore(),
          Divider(),
          menuLogOutStore(),
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
