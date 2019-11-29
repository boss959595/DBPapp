import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/report_model.dart';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/models/user_model.dart';
import 'package:dbpapp/screens/search_electric.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:date_format/date_format.dart';
import 'my_dialog.dart';
import 'my_style.dart';
import 'package:http/http.dart' as http;

class ShowDetailElectric extends StatefulWidget {
  final EquipmentElectricModel equipmentElectricModel;
  ShowDetailElectric({Key key, this.equipmentElectricModel}) : super(key: key);
  @override
  _ShowDetailElectricState createState() => _ShowDetailElectricState();
}

class _ShowDetailElectricState extends State<ShowDetailElectric> {
  // Explicit
  ReportElectricModel myReportElectricModel;
  EquipmentElectricModel myEquipmentElectricModel;
  final formKey = GlobalKey<FormState>();
  UserAccoutModel userAccoutModel;
  String loginString = '';
  UserModel userModel;
  String userString,
      levelString = '',
      keyString,
      sizeString,
      setupString,
      placeString,
      limitString,
      numberString,
      nameString,
      placeStatusString = 'นำเข้า';

  

  // Medthod
  @override
  void initState() {
    super.initState();
    setState(() {
      myEquipmentElectricModel = widget.equipmentElectricModel;
      findUser();
    });
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
    findLevel();
    findNameLogin();
  }

  Future findLevel() async {
    String url = '${MyStyle().urlGetUser}$userString';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('find LV = $result');
    for (var map in result) {
      userAccoutModel = UserAccoutModel.fromJSON(map);
      setState(() {
        levelString = userAccoutModel.level;
      });
    }
  }

  Future<void> findNameLogin() async {
    String url = '${MyStyle().urlGetName}$userString';
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


  Widget barEditEquipment() {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        showEditEquipment();
      },
    );
  }

  void showEditEquipment() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 5.0),
            contentPadding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 0.0),
            title: Text(
              'แก้ไขข้อมูลวัสดุหรืออุปกรณ์',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: showEditEquipment1(),
            ),
            actions: <Widget>[
              okEditButton(),
              cancelButton(),
            ],
          );
        });
  }

  Widget showEditEquipment1() {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            initialValue: "${myEquipmentElectricModel.keyEqEe}",
            decoration: InputDecoration(
              labelText: 'รหัส Motor',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ รหัส Motor';
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
            initialValue: "${myEquipmentElectricModel.sizeEqEe}",
            decoration: InputDecoration(
              labelText: 'ขนาด Motor',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ ขนาด Motor';
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
            initialValue: "${myEquipmentElectricModel.setupEqEe}",
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
            initialValue: "${myEquipmentElectricModel.placeEqEe}",
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
            initialValue: "${myEquipmentElectricModel.limitEqEe}",
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
        ],
      ),
    );
  }

  Widget okEditButton() {
    return OutlineButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          editEquipment();
          Navigator.of(context).pop();
        }
      },
      borderSide: BorderSide(color: Colors.lightGreenAccent),
    );
  }

  Future<void> editEquipment() async {
     print(
        'bossx = ${myEquipmentElectricModel.idEqEe},$sizeString, $setupString, $placeString, $limitString , $keyString');

    String url =
        'https://iot-en.me/api/editEquipmentWhereIdElectric.php/?isAdd=true&id_eq_ee=${myEquipmentElectricModel.idEqEe}&key_eq_ee=$keyString&size_eq_ee=$sizeString&setup_eq_ee=$setupString&place_eq_ee=$placeString&total_eq_ee=${myEquipmentElectricModel.totalEqEe}&limit_eq_ee=$limitString';

    Response response = await get(url);
    var result = json.decode(response.body);
    print('XXX = $result');

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
      normalAlert(
          context, 'ผิดพลาด', 'กรุณา กรอกค่าแจ้งเตือน มากกว่า 1 ขึ้นไป');
    }
  }

  Widget cancelButton() {
    return OutlineButton(
      child: Text('ยกเลิก'),
      onPressed: () {
        Navigator.of(context).pop();
      },
      borderSide: BorderSide(color: Colors.red[300]),
    );
  }

  Widget barDeleteEquipment() {
    return IconButton(
      icon: Icon(Icons.delete),
      onPressed: () {
        showConfirm();
      },
    );
  }

  void showConfirm() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
            contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 20.0),
            title: Text(
              'คุณแน่ใจแล้วใช่มั้ยว่าจะลบ',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red),
            ),
            actions: <Widget>[
              okDelete(),
              cancelButton(),
            ],
          );
        });
  }

  Widget okDelete() {
    return OutlineButton(
      child: Text('ตกลง'),
      onPressed: () {
        processOkDelete();
        Navigator.of(context).pop();
      },
      borderSide: BorderSide(
        color: Colors.lightGreenAccent,
      ),
    );
  }

  Future<void> processOkDelete() async {
    String url =
        'https://iot-en.me/api/deleteEquipmentWhereIdElectric.php?isAdd=true&id=${myEquipmentElectricModel.idEqEe}';
    await get(url);
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) => SearchElectric());
    Navigator.of(context).push(materialPageRoute);
  }

  Widget myKey() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'รหัส Motor : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentElectricModel.keyEqEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget mySize() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ขนาด Motor : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentElectricModel.sizeEqEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget mySetup() {
    return Row(
      children: <Widget>[
        Text(
          'ลักษณะการติดตั้ง : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentElectricModel.setupEqEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myPlace() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'สถานที่ใช้งาน : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentElectricModel.placeEqEe}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myTotal() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'จำนวนคงเหลือ',
          style: TextStyle(fontSize: 40, color: Colors.lightBlue),
        ),
        Stack(
          children: <Widget>[
            Text(
              '${myEquipmentElectricModel.totalEqEe}',
              style: TextStyle(
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.red,
              ),
            ),
            Text(
              '${myEquipmentElectricModel.totalEqEe}',
              style: TextStyle(
                fontSize: 40,
                color: Colors.yellowAccent,
              ),
            )
          ],
        ),
        Text(
          'EA',
          style: TextStyle(fontSize: 40, color: Colors.lightBlue),
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
          ),
          SizedBox(
            height: 5.0,
          ),
          index == 1 ? placeUse() : SizedBox(),
        ],
      ),
    );
  }

  Widget placeUse() {
    return TextFormField(
      initialValue: 'นำออก ',
      decoration: InputDecoration(
        labelText: 'สถานที่นำไปใช้งาน',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow.shade600),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'กรุณาใส่สถานที่';
        } else {
          return null;
        }
      },
      onSaved: (value) {
        placeStatusString = value.trim();
      },
    );
  }

  Widget okButton(int index) {
    return OutlineButton(
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
      borderSide: BorderSide(
        color: Colors.lightGreenAccent[400],
      ),
    );
  }

  Future<void> increaseAndDecreaseProcess(String process) async {
    String idEqEe = myEquipmentElectricModel.idEqEe;
    String totalString = myEquipmentElectricModel.totalEqEe;
    int totalAInt = int.parse(totalString);
    int numberAInt = int.parse(numberString);

    if (process == '0') {
      totalAInt = totalAInt + numberAInt;
      String url =
          'https://iot-en.me/api/updateEquipmentWhereIdElectric.php?isAdd=true&id_eq_ee=$idEqEe&total_eq_ee=$totalAInt';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        print('EQM + success');
        insertReport('0', totalAInt);
      } else {
        normalAlert(context, 'ข้อมูลผิดพลาด', 'กรุณาลองใหม่');
      }
    } else {
      totalAInt = totalAInt - numberAInt;
      String url =
          'https://iot-en.me/api/updateEquipmentWhereIdElectric.php?isAdd=true&id_eq_ee=$idEqEe&total_eq_ee=$totalAInt';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        print('EQM - success');
        insertReport('1', totalAInt);
      } else {
        normalAlert(context, 'ข้อมูลผิดพลาด', 'กรุณาลองใหม่');
      }
    }

    String limitString = myEquipmentElectricModel.limitEqEe;
    int limitAInt = int.parse(limitString);
    if (totalAInt <= limitAInt) {
      // Call limit line api
      callLineAPI(totalAInt);
    }
  }

  Future<void> insertReport(String process, int totalAInt) async {
    String user = nameString;
    String key = myEquipmentElectricModel.keyEqEe;
    String size = myEquipmentElectricModel.sizeEqEe;
    String setup = myEquipmentElectricModel.setupEqEe;
    String place = myEquipmentElectricModel.placeEqEe;
    String total = '${myEquipmentElectricModel.totalEqEe} -> $totalAInt';

    if (process == '1') {
      String url =
          'https://iot-en.me/api/addReportElectric.php?isAdd=true&key_rp_ee=$key&user_rp_ee=$user&size_rp_ee=$size&setup_rp_ee=$setup&place_rp_ee=$place&total_rp_ee=$total&process_rp_ee=$process&status_rp_ee=$placeStatusString&admin_rp_ee=$loginString';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => SearchElectric());
        Navigator.of(context).push(materialPageRoute);
      } else {
        normalAlert(context, 'ผิดพลาด', 'กรุณาลองใหม่');
      }
    } else {
      String url =
          'https://iot-en.me/api/addReportElectric.php?isAdd=true&key_rp_ee=$key&user_rp_ee=$user&size_rp_ee=$size&setup_rp_ee=$setup&place_rp_ee=$place&total_rp_ee=$total&process_rp_ee=$process&status_rp_ee=$placeStatusString&admin_rp_ee=$loginString';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
            builder: (BuildContext context) => SearchElectric());
        Navigator.of(context).push(materialPageRoute);
      } else {
        normalAlert(context, 'ผิดพลาด', 'กรุณาลองใหม่');
      }
    }
  }

  Future<void> decreaseProcess() async {
    String currentTotal = myEquipmentElectricModel.totalEqEe;
    int currentTotalAInt = int.parse(currentTotal);
    int numberDecrease = int.parse(numberString);

    if (numberDecrease > currentTotalAInt) {
      normalAlert(context, 'ผิดพลาด', 'ของมีจำนวนน้อยกว่าที่เบิก');
    } else {
      // int totalAInt = currentTotalAInt - numberDecrease;

      increaseAndDecreaseProcess('1');
      // insertReport('1', totalAInt);
    }
  }

  Future<http.Response> callLineAPI(int totalAInt) async {
    String realTime =
        formatDate(DateTime.now(), [dd, '/', mm, '/', yyyy, ' ', HH, ':', nn]);
    //print('VVVV = ${totalAInt}');

    String message =
        '\n ขณะนี้มีจำนวนต่ำกว่าที่กำหนดคือ ${myEquipmentElectricModel.limitEqEe} \n\n ลงวันที่ : $realTime \n ขนาด Motor : ${myEquipmentElectricModel.sizeEqEe} \n การติดตั้ง : ${myEquipmentElectricModel.setupEqEe} \n สถานที่ใช้งาน : ${myEquipmentElectricModel.placeEqEe} \n จำนวนคงเหลือ : ${totalAInt} EA';
    String stickerLineGroup = '1';
    String stickerLineId = '3';

    var url = 'https://notify-api.line.me/api/notify';
    Map data = {
      'message': '$message',
      'stickerPackageId': '$stickerLineGroup',
      'stickerId': '$stickerLineId',
    };

    //encode Map to JSON = var body = json.encode(data);
    var body = data;

    var response = await http.post(url,
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
          "Authorization": "Bearer s1mg5tgZjQICeHgjLSzGbG39kLbVAsDbTilYurdZ2W4",
        },
        body: body);
    print("responseCode ${response.statusCode}");
    print("responseAll ${response.body}");
    return response;
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
        actions: <Widget>[
          levelString == '2' ? barDeleteEquipment() : SizedBox(),
          levelString == '2' ? barEditEquipment() : SizedBox(),
        ],
        // actions: <Widget>[testLine()],
        backgroundColor: Colors.yellowAccent,
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
                myKey(),
                Divider(),
                mySize(),
                Divider(),
                mySetup(),
                Divider(),
                myPlace(),
                Divider(),
                myTotal(),
              ],
            ),
          ),
          levelString == '2' ? myButton() : SizedBox(),
        ],
      ),
    );
  }
}
