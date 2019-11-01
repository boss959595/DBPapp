import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/my_center.dart';
import 'package:dbpapp/screens/my_dialog.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/search_center.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

//stl
class ShowDetailCenter extends StatefulWidget {
  final EquipmentModel equipmentModel;
  ShowDetailCenter({Key key, this.equipmentModel}) : super(key: key);
  @override
  _ShowDetailCenterState createState() => _ShowDetailCenterState();
}

class _ShowDetailCenterState extends State<ShowDetailCenter> {
  // Explicit
  EquipmentModel myEquipmentModel;
  String userString, levelString = '', numberString, nameString;
  final formKey = GlobalKey<FormState>();

  // Method
  @override
  void initState() {
    super.initState();
    setState(() {
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
      UserAccoutModel userAccoutModel = UserAccoutModel.fromJSON(map);
      setState(() {
        levelString = userAccoutModel.level;
      });
    }
  }

  Widget showName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อ    :  ${myEquipmentModel.name}',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ],
    );
  }

  Widget contentRow1() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[myGroup(), myType()],
    );
  }

  Widget myGroup() {
    return Text(
      'กลุ่ม :  ${myEquipmentModel.group}',
      style: TextStyle(fontSize: MyStyle().h2),
    );
  }

  Widget myType() {
    return Text(
      'ประเภท :  ${myEquipmentModel.type}',
      style: TextStyle(fontSize: MyStyle().h2),
    );
  }

  Widget myTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'จำนวนคงเหลือ : ${myEquipmentModel.total} ${myEquipmentModel.unit}',
          style: TextStyle(fontSize: MyStyle().h1),
        ),
      ],
    );
  }

  Widget myButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            increaseButton(),
            decreaseButton(),
          ],
        ),
      ],
    );
  }

  Widget increaseButton() {
    return Expanded(
      child: RaisedButton.icon(
        color: Colors.lightGreen,
        icon: Icon(Icons.add_shopping_cart),
        label: Text(
          'เพิ่ม',
          style: TextStyle(color: Colors.black),
        ),
        onPressed: () {
          showAlert(0);
        },
      ),
    );
  }

  Widget decreaseButton() {
    return Expanded(
      child: RaisedButton.icon(
        color: Colors.red.shade500,
        icon: Icon(Icons.remove_shopping_cart),
        label: Text('ลด'),
        onPressed: () {
          showAlert(1);
        },
      ),
    );
  }

  Widget showTitle(int index) {
    List<IconData> titleIcons = [Icons.add, Icons.remove];
    List<String> titles = ['การเพิ่มจำนวน', 'การลดจำนวน'];

    return ListTile(
      leading: Icon(
        titleIcons[index],
        size: 36.0,
      ),
      title: Text(
        titles[index],
        style: TextStyle(
          fontSize: MyStyle().h2,
        ),
      ),
    );
  }

  Widget showContent(int index) {
    List<String> labels = ['ใส่จำนวนที่ต้องการเพิ่ม', 'ใส่จำนวนที่ต้องการลด'];

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
              labelText: labels[index],
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่จำนวน';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              numberString = value.trim();
            },
          ),
          SizedBox(
            height: 5.0,
          ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'ชื่อผู้ทำรายการ',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ชื่อผู้ทำรายการ';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              nameString = value.trim();
            },
          )
        ],
      ),
    );
  }

  Widget cancelButton() {
    return FlatButton(
      child: Text('ยกเลิก'),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }

  Widget okButton(int index) {
    return FlatButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          print('number = $numberString, name = $nameString, index = $index');
          if (index == 0) {
            increaseAndDecreaseProcess('0');
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
            decreaseProcess();
          }
        }
      },
    );
  }

  Future<void> increaseAndDecreaseProcess(String process) async {
    String ideq = myEquipmentModel.idEq;
    String totalString = myEquipmentModel.total;
    int totalAInt = int.parse(totalString);
    int numberAInt = int.parse(numberString);

    if (process == '0') {
      totalAInt = totalAInt + numberAInt;
    } else {
      totalAInt = totalAInt - numberAInt;
    }

    String url =
        'https://www.androidthai.in.th/boss/editEquipmentWhereIdboss.php?isAdd=true&id_eq=$ideq&total=$totalAInt';
    Response response = await get(url);
    var result = json.decode(response.body);
    if (result.toString() == 'true') {
      print('EQM success');
      insertReport('0', totalAInt);
    } else {
      normalAlert(context, 'ข้อมูลผิดพลาด', 'กรุณาลองใหม่');
    }
  }

  Future<void> insertReport(String process, int totalAInt) async {
    String key = myEquipmentModel.key;
    String group = myEquipmentModel.group;
    String type = myEquipmentModel.type;
    String unit = myEquipmentModel.unit;
    String total = '${myEquipmentModel.total} -> $totalAInt';
    String myProcess = process;

    String url =
        'https://www.androidthai.in.th/boss/addReportBoss.php?isAdd=true&key_re=$key&user_re=$nameString&group_re=$group&type_re=$type&unit_re=$unit&total_re=$total&process_re=$myProcess';

    Response response = await get(url);
    var result = json.decode(response.body);
    if (result.toString() == 'true') {
      MaterialPageRoute materialPageRoute = MaterialPageRoute(
        builder: (BuildContext context) => MyCenter(),
      );
      Navigator.of(context).pushAndRemoveUntil(
          materialPageRoute, (Route<dynamic> route) => false);
    } else {
      normalAlert(context, 'ผิดพลาด', 'กรุณาลองใหม่');
    }
  }

  Future<void> decreaseProcess() async {
    String currentTotal = myEquipmentModel.total;
    int currentTotalAInt = int.parse(currentTotal);
    int numberDecrease = int.parse(numberString);

    if (numberDecrease > currentTotalAInt) {
      normalAlert(context, 'ผิดพลาด', 'ของมีจำนวนน้อยกว่าที่เบิก');
    } else {
      int totalAInt = currentTotalAInt - numberDecrease;
      String limitString = myEquipmentModel.limit;
      int limitAInt = int.parse(limitString);

      if (totalAInt <= limitAInt) {
        // Call limit line api
      }
      increaseAndDecreaseProcess('1');
      insertReport('1', totalAInt);
    }
  }

  void showAlert(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            title: showTitle(index),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: showContent(index),
            ),
            actions: <Widget>[
              okButton(index),
              cancelButton(),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        iconTheme: IconTheme.of(context),
        title: Text(
          'รายละเอียด',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(30.0),
            child: Column(
              children: <Widget>[
                contentRow1(),
                Divider(),
                showName(),
                Divider(),
                myTotal(),
              ],
            ),
          ),
          levelString == '1' ? myButton() : SizedBox(),
        ],
      ),
    );
  }
}
