import 'dart:async';
import 'dart:convert';
import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/search_detail_electric.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart';
import 'my_dialog.dart';
import 'my_style.dart';

class SearchElectric extends StatefulWidget {
  final EquipmentElectricModel equipmentElectricModel;
  SearchElectric({Key key, this.equipmentElectricModel}) : super(key: key);

  @override
  _SearchElectricState createState() => _SearchElectricState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _SearchElectricState extends State<SearchElectric> {
  // Explicit
  EquipmentElectricModel myEquipmentElectricModel;
  List<EquipmentElectricModel> equipmentElectricModels = [];
  List<EquipmentElectricModel> filterEquipmentElectricModels = List();
  final debouncer = Debouncer(milliseconds: 500);
  final formKey = GlobalKey<FormState>();
  UserAccoutModel userAccoutModel;

  String userString,
      levelString = '',
      keyString,
      sizeString,
      setupString,
      placeString,
      totalString,
      limitString;

  // Medthod

  @override
  void initState() {
    super.initState();
    setState(() {
      readAllData();
      myEquipmentElectricModel = widget.equipmentElectricModel;
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
      setState(
        () {
          levelString = userAccoutModel.level;
        },
      );
    }
  }

  Future<void> readAllData() async {
    String url =
        'https://iot-en.me/api/getAllEquipmentElectric.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');
    for (var map in result) {
      EquipmentElectricModel equipmentElectricModel =
          EquipmentElectricModel.formJSON(map);
      print('name = ${equipmentElectricModel.sizeEqEe}');
      setState(() {
        equipmentElectricModels.add(equipmentElectricModel);
        filterEquipmentElectricModels = equipmentElectricModels;
      });
    }
  }

  Widget searchText() {
    return TextField(
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow.shade600),
          borderRadius: BorderRadius.circular(20.0),
        ),
        prefixIcon: Icon(Icons.search),
        hintText: 'ค้นหา',
      ),
      onChanged: (value) {
        debouncer.run(() {
          setState(() {
            filterEquipmentElectricModels = equipmentElectricModels
                .where((u) =>
                    (u.sizeEqEe.toLowerCase().contains(value.toLowerCase())))
                .toList();
          });
        });
      },
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: filterEquipmentElectricModels.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: Card(
              child: Container(
                padding: EdgeInsets.fromLTRB(0.0, 0.0, 8.0, 0.0),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.play_arrow,
                      color: Colors.grey,
                    ),
                    Container(
                      width: 260.0,
                      child: Wrap(
                        children: <Widget>[
                          Container(
                              child: Wrap(
                            children: <Widget>[
                              showSize(index),
                            ],
                          )),
                        ],
                      ),
                    ),
                    Container(
                      width: 60.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          showTotal(index),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              //print('You click ${filterEquipmentModels[index].name}');
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => ShowDetailElectric(
                        equipmentElectricModel:
                            filterEquipmentElectricModels[index],
                      ));
              Navigator.of(context).push(materialPageRoute);
            },
          );
        },
      ),
    );
  }

  Widget showSize(int index) {
    return Text(
      filterEquipmentElectricModels[index].sizeEqEe,
      style: TextStyle(
        fontSize: MyStyle().h2,
        color: Colors.orange,
      ),
    );
  }

  Widget showTotal(int index) {
    return Text(
      filterEquipmentElectricModels[index].totalEqEe,
      style: TextStyle(
        fontSize: MyStyle().h1,
        color: Colors.lightBlueAccent[700],
      ),
    );
  }

  Widget addEquipment() {
    return IconButton(
      icon: Icon(Icons.add_box),
      onPressed: () {
        showAddEquipment();
      },
    );
  }

  void showAddEquipment() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
            contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 20.0),
            title: Text(
              'เพิ่ม Motor',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: showAddEquipment1(),
            ),
            actions: <Widget>[
              okButton(),
              cancelButton(),
            ],
          );
        });
  }

  Widget showAddEquipment1() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'รหัส Motor',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่รหัส Motor';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              keyString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ขนาด Motor',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ขนาด Motor';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              sizeString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ลักษณะการติดตั้ง',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ ลักษณะการติดตั้ง';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              setupString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'สถานที่ใช้งาน',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ สถานที่ใช้งาน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              placeString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'การแจ้งเตือนเมื่อ < หรือ =',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่จำนวนที่ต้องการแจ้งเตือน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              limitString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'จำนวน',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ จำนวนปัจจุบัน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              totalString = value.trim();
            },
          )
        ],
      ),
    );
  }

  Widget okButton() {
    return OutlineButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print(
              'boss = $keyString, $sizeString, $setupString, $placeString, $totalString, $limitString');
          insertEquipment();
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

  Future<void> insertEquipment() async {
    int xlimitString = int.parse(limitString);
    int xtotalString = int.parse(totalString);

    print(
        'object=$keyString ,$sizeString, $setupString, $placeString, $totalString, $limitString');

    String url =
        'https://iot-en.me/api/addEquipmentElectric.php?isAdd=true&key_eq_ee=$keyString&size_eq_ee=$sizeString&setup_eq_ee=$setupString&place_eq_ee=$placeString&total_eq_ee=$xtotalString&limit_eq_ee=$xlimitString';

    Response response = await get(url);
    var result = json.decode(response.body);

    if (result.toString() == 'true') {
      print('insert Equipment Success');
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (BuildContext context) => Store(
          userAccoutModel: userAccoutModel,
        ),
      );
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    } else {
      normalAlert(context, 'ผิดพลาด',
          'กรุณา กรอกค่าแจ้งเตือน และ จำนวนของ มากกว่า 1 ขึ้นไป');
    }
  }

  Widget headColumn() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 1.0, 5.0, 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'ขนาด Motor',
            style: TextStyle(
              fontSize: 20,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Colors.orange[700],
            ),
          ),
          Text(
            'จำนวน',
            style: TextStyle(
              fontSize: 20,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = Colors.lightBlueAccent[700],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          levelString == '2' ? addEquipment() : SizedBox(),
        ],
        iconTheme: IconTheme.of(context),
        backgroundColor: Colors.yellowAccent,
        title: Text(
          'Motor', //คลังเครื่องกล
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
            child: searchText(),
          ),
          headColumn(),
          showListView(),
        ],
      ),
    );
  }
}
