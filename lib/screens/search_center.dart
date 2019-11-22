import 'dart:convert';
import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/searcth_detail_center.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_dialog.dart';

class SearchCenter extends StatefulWidget {
  final EquipmentModel equipmentModel;
  SearchCenter({Key key, this.equipmentModel}) : super(key: key);

  @override
  _SearchViewMaterialState createState() => _SearchViewMaterialState();
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

class _SearchViewMaterialState extends State<SearchCenter> {
  // Explicit
  EquipmentModel myEquipmentModel;
  List<EquipmentModel> equipmentModels = [];
  List<EquipmentModel> filterEquipmentModels = List();
  final debouncer = Debouncer(milliseconds: 500);
  final formKey = GlobalKey<FormState>();
  UserAccoutModel userAccoutModel;

  String userString,
      levelString = '',
      keyString,
      nameString,
      typeString,
      groupString,
      unitString,
      limitString,
      totalString;

  // Method

  @override
  void initState() {
    super.initState();
    setState(() {
      readAllData();
      myEquipmentModel = widget.equipmentModel;
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
    String url = 'https://iot-en.me/api/getAllEquipmentBoss.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('result = $result');
    for (var map in result) {
      EquipmentModel equipmentModel = EquipmentModel.formJSON(map);
      print('name = ${equipmentModel.name}');
      setState(() {
        equipmentModels.add(equipmentModel);
        filterEquipmentModels = equipmentModels;
      });
    }
  }

  // enabledBorder: OutlineInputBorder(
  //         borderSide: BorderSide(color: Colors.yellow.shade600),
  //         borderRadius: BorderRadius.circular(20.0),
  //       ),

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
            filterEquipmentModels = equipmentModels
                .where(
                    (u) => (u.name.toLowerCase().contains(value.toLowerCase())))
                .toList();
          });
        });
      },
    );
  }

  Widget showListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: filterEquipmentModels.length,
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
                              showName(index),
                            ],
                          )),
                          // showName(index),
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
                  builder: (BuildContext context) => ShowDetailCenter(
                        equipmentModel: filterEquipmentModels[index],
                      ));
              Navigator.of(context).push(materialPageRoute);
            },
          );
        },
      ),
    );
  }

  Widget showName(int index) {
    return Text(
      filterEquipmentModels[index].name,
      style: TextStyle(
        fontSize: MyStyle().h2,
        color: Colors.orange,
      ),
    );
  }

  Widget showTotal(int index) {
    return Text(
      filterEquipmentModels[index].total,
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
              'เพิ่มวัสดุหรืออุปกรณ์',
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
              keyString = value.trim();
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
              nameString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ประเภท',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ประเภท';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              typeString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'กลุ่ม',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่กลุ่ม';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              groupString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'หน่วยนับ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่หน่วยนับ';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              unitString = value.trim();
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
                return 'กรุณาใส่จำนวนปัจจุบัน';
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
              'boss = $keyString, $nameString, $typeString, $groupString, $unitString, $limitString, $totalString');
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
    //  String xlimitString = limitString;
    //  String xtotalString = totalString;
    int xlimitString = int.parse(limitString);
    int xtotalString = int.parse(totalString);

    print(
        'object=$keyString,$nameString,$typeString,$groupString,$unitString,$xlimitString,$xtotalString');

    String url =
        'https://iot-en.me/api/addEquipmentBoss.php?isAdd=true&key=$keyString&name=$nameString&type=$typeString&group=$groupString&unit=$unitString&limit=$xlimitString&total=$xtotalString';

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
            'ชื่อ',
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
          levelString == '1' ? addEquipment() : SizedBox(),
        ],
        iconTheme: IconTheme.of(context),
        backgroundColor: Colors.orange,
        title: Text(
          'วัสดุ และ อุปกรณ์', //คลังเครื่องกล
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
