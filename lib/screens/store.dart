import 'dart:convert';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/models/user_model.dart';
import 'package:dbpapp/screens/change_password.dart';
import 'package:dbpapp/screens/home.dart';
import 'package:dbpapp/screens/my_center.dart';
import 'package:dbpapp/screens/my_electric.dart';
import 'package:dbpapp/screens/my_machine.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> titleAppBars = ['คลังเครื่องกล', 'คลังไฟฟ้า', 'คลังกลาง'];
  int indexTitleAppBars =0;
  Widget currentWiget = MyCenter();
  List<Color> colorAppBars = [
    MyStyle().appBarCenter,
    MyStyle().appBarElectric,
    MyStyle().appBarMachine
  ];

  // Method
  void closeDrawer() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    _userAccoutModel = widget.userAccoutModel;
    print('userLogin =${_userAccoutModel.user},${_userAccoutModel.level}');
    findNameLogin();
  }

  Widget menuCenterStore() {
    return ListTile(
      leading: Icon(
        Icons.build,
        size: 36.0,
        color: Colors.orange[600],
      ),
      title: Text('คลังเครื่องกล'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        setState(() {
          indexTitleAppBars = 0;
          currentWiget = MyCenter();
        });
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
        setState(() {
          indexTitleAppBars = 1;
          currentWiget = MyElectric();
        });
        closeDrawer();
      },
    );
  }

  Widget menuMachineStore() {
    return ListTile(
      leading: Icon(
        Icons.filter_tilt_shift,
        size: 36.0,
        color: Colors.brown[600],
      ),
      title: Text('คลังกลาง'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        setState(() {
          indexTitleAppBars = 2;
          currentWiget = MyMachine();
        });
        closeDrawer();
      },
    );
  }

  Widget menuRegisterStore() {
    return ListTile(
      leading: Icon(
        Icons.group_add,
        size: 36.0,
        color: Colors.green[600],
      ),
      title: Text('สมัครสมาชิก'),
      subtitle: Text('คำอธิบาย'),
      onTap: () {
        closeDrawer();
        MaterialPageRoute materialPageRoute =
            MaterialPageRoute(builder: (BuildContext context) => Register());
        Navigator.of(context).push(materialPageRoute);
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
    print('result findNameLogin = $result');
    for (var map in result) {
      setState(() {
        userModel = UserModel.fromJson(map);
        loginString = userModel.name;
        print('loginString = $loginString');
      });
    }
  }

  Widget iconLogout() {
    return IconButton(
      tooltip: 'ออกระบบ',
      icon: Icon(
        Icons.exit_to_app,
        color: Colors.red,
        size: 36.0,
      ),
      onPressed: () {
        processLogOut();
      },
    );
  }

  Future<void> processLogOut() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();

    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) => Home());
    Navigator.of(context)
        .pushAndRemoveUntil(materialPageRoute, (Route<dynamic> route) => false);
  }

  Widget iconChangePassword() {
    return IconButton(
      tooltip: 'เปลี่ยนพาสเวิร์ด',
      icon: Icon(
        Icons.lock,
        color: Colors.green.shade600,
        size: 36.0,
      ),
      onPressed: () {
        closeDrawer();
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => ChangePassword());
        Navigator.of(context).push(materialPageRoute);
      },
    );
  }

  Widget showLogin() {
    return Text(
      '$loginString',
      style: TextStyle(
        color: Colors.orange,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget showAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 85.0,
          height: 85.0,
          child: Image.asset('images/avatar.png'),
        ),
      ],
    );
  }

  Widget spcialButton() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        iconChangePassword(),
        iconLogout(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                width: 176,
                child: Wrap(
                  children: <Widget>[
                    showLogin(),
                  ],
                ),
              ),
              Container(
                child: spcialButton(),
              ),
            ],
          ),
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
          SizedBox(
            height: 180.0,
          ),

          _userAccoutModel.level == '1' ? Divider() : SizedBox(),
          _userAccoutModel.level == '2' ? Divider() : SizedBox(),
          //menuRegisterStore(),
          _userAccoutModel.level == '1' ? menuRegisterStore() : SizedBox(),
          _userAccoutModel.level == '2' ? menuRegisterStore() : SizedBox(),
          // menuChangePassStore(),
          // Divider(),
          // menuLogOutStore(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconTheme.of(context),
        backgroundColor: colorAppBars[indexTitleAppBars],
        title: Text(
          titleAppBars[indexTitleAppBars],
          style: TextStyle(color: Colors.black),
        ),
      ),
      // body: SingleChildScrollView(
      //   child: showDrawer(),
      // ),
      body: currentWiget,
      drawer: showDrawer(),
    );
  }
}
