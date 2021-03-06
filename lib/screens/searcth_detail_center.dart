import 'dart:convert';
import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/report_model.dart';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/models/user_model.dart';
import 'package:dbpapp/screens/my_dialog.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/search_center.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:date_format/date_format.dart';
//import 'package:dio/dio.dart';

//stl
class ShowDetailCenter extends StatefulWidget {
  final EquipmentModel equipmentModel;
  ShowDetailCenter({Key key, this.equipmentModel}) : super(key: key);
  @override
  _ShowDetailCenterState createState() => _ShowDetailCenterState();
}

class _ShowDetailCenterState extends State<ShowDetailCenter> {
  // Explicit
  ReportModel myReportModel;
  String loginString = '';
  UserModel userModel;
  EquipmentModel myEquipmentModel;
  final formKey = GlobalKey<FormState>();
  UserAccoutModel userAccoutModel;
  String userString,
      levelString = '',
      numberString,
      nameString,
      xkeyString,
      xnameString,
      xtypeString,
      xgroupString,
      xunitString,
      xlimitString,
      placeString = 'นำเข้า',
      noString,
      becauseString;

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
    print('UserString = $userString');
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
              'แก้ไขข้อมูลอะไหล่',
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
            initialValue: "${myEquipmentModel.key}",
            decoration: InputDecoration(
              labelText: 'รหัสอะไหล่',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่รหัสอะไหล่';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              xkeyString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: "${myEquipmentModel.name}",
            decoration: InputDecoration(
              labelText: 'ชื่ออะไหล่',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่ชื่ออะไหล่';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              xnameString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: "${myEquipmentModel.type}",
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
              xtypeString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: "${myEquipmentModel.group}",
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
              xgroupString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: "${myEquipmentModel.unit}",
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
              xunitString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: "${myEquipmentModel.limit}",
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
              xlimitString = value.trim();
            },
          ),
           SizedBox(
            height: 3.0,
          ),
          TextFormField(
            initialValue: "${myEquipmentModel.total}",
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'จำนวนอะไหล่',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.yellow.shade600),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'กรุณาใส่จำนวนอะไหล่';
              } else {
                return null;
              }
            },
            onSaved: (value) {
              xlimitString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
        ],
      ),
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
    String idDeleteEquipment = myEquipmentModel.idEq;
    int xidDeleteEquipment = int.parse(idDeleteEquipment);
    //print(idDeleteEquipment);

    String url =
        'https://iot-en.me/api/deleteEquipmentWhereIdBoss.php?isAdd=true&id_eq=$xidDeleteEquipment';
    await get(url);
    MaterialPageRoute materialPageRoute =
        MaterialPageRoute(builder: (BuildContext context) => SearchCenter());
    Navigator.of(context).push(materialPageRoute);
  }

  // Widget contentRow1() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //     children: <Widget>[myGroup(), myType()],
  //   );
  // }

  Widget myGroup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'กลุ่ม : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentModel.group}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget myType() {
    return Row(
      children: <Widget>[
        Text(
          'ประเภท : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentModel.type}',
            softWrap: false,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: MyStyle().h2),
          ),
        ),
      ],
    );
  }

  Widget showName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          'ชื่อ : ',
          style: TextStyle(
              fontSize: MyStyle().h2, color: Colors.lightBlueAccent[700]),
        ),
        Flexible(
          fit: FlexFit.loose,
          child: Text(
            '${myEquipmentModel.name}',
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
              '${myEquipmentModel.total}',
              style: TextStyle(
                fontSize: 40,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 5
                  ..color = Colors.red,
              ),
            ),
            Text(
              '${myEquipmentModel.total}',
              style: TextStyle(
                fontSize: 40,
                color: Colors.yellowAccent,
              ),
            )
          ],
        ),
        Text(
          '${myEquipmentModel.unit}',
          style: TextStyle(fontSize: 40, color: Colors.lightBlue),
        ),
      ],
    );
  }

  Widget adminButton() {
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

  Widget miniAdminButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
            increaseButton(),
          ],
        ),
      ],
    );
  }

  Widget userButton() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          children: <Widget>[
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
          TextFormField(initialValue: "${loginString}",
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
          SizedBox(
            height: 5.0,
          ),
          index == 1 ? noUse() : SizedBox(),
          SizedBox(
            height: 5.0,
          ),
          index == 1 ? becauseUse() : SizedBox(),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }

  Widget noUse() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'No.',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow.shade600),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onSaved: (value) {
        noString = value.trim();
      },
    );
  }

  Widget becauseUse() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'สาเหตุ/การชำรุด',
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow.shade600),
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      onSaved: (value) {
        becauseString = value.trim();
      },
    );
  }

  Widget placeUse() {
    return TextFormField(
      initialValue: 'นำไปใช้งาน ',
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
        placeString = value.trim();
      },
    );
  }

  Widget okEditButton() {
    return OutlineButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          //print('boss = $xkeyString, $xnameString, $xtypeString, $xgroupString, $xunitString, $xlimitString');
          editEquipment();
          Navigator.of(context).pop();
        }
      },
      borderSide: BorderSide(color: Colors.lightGreenAccent),
    );
  }

  Future<void> editEquipment() async {
    String idDeleteEquipment = myEquipmentModel.idEq;
    int xidDeleteEquipment = int.parse(idDeleteEquipment);
    int xxlimitString = int.parse(xlimitString);

    print(
        'tiwz = $xidDeleteEquipment,$xkeyString, $xnameString, $xtypeString, $xgroupString, $xunitString, $xxlimitString');

    String url =
        'https://iot-en.me/api/editEquipmentWhereIdboss.php/?isAdd=true&id_eq=$xidDeleteEquipment&key=$xkeyString&name=$xnameString&type=$xtypeString&group=$xgroupString&unit=$xunitString&limit=$xxlimitString';

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
    String ideq = myEquipmentModel.idEq;
    String totalString = myEquipmentModel.total;
    int totalAInt = int.parse(totalString);
    int numberAInt = int.parse(numberString);

    if (process == '0') {
      totalAInt = totalAInt + numberAInt;
      String url =
          'https://iot-en.me/api/updateEquipmentWhereIdboss.php?isAdd=true&id_eq=$ideq&total=$totalAInt';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        print('EQM success');
        insertReport(process, totalAInt);
      } else {
        normalAlert(context, 'ข้อมูลผิดพลาด', 'กรุณาลองใหม่');
      }
    } else {
      totalAInt = totalAInt - numberAInt;
      String url =
          'https://iot-en.me/api/updateEquipmentWhereIdboss.php?isAdd=true&id_eq=$ideq&total=$totalAInt';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        print('EQM success');
        insertReport(process, totalAInt);
      } else {
        normalAlert(context, 'ข้อมูลผิดพลาด', 'กรุณาลองใหม่');
      }
    }

    String limitString = myEquipmentModel.limit;
    int limitAInt = int.parse(limitString);
    if (totalAInt <= limitAInt) {
      // Call limit line api
      callLineAPI(totalAInt);
    }
  }

  Future<void> insertReport(String process, int totalAInt) async {
    String key = myEquipmentModel.key;
    String group = myEquipmentModel.group;
    String type = myEquipmentModel.type;
    String nameEqString = myEquipmentModel.name;
    String unit = myEquipmentModel.unit;
    String total = '${myEquipmentModel.total} -> $totalAInt';

    if (process == '1') {
      String url =
          'https://iot-en.me/api/addReportBoss.php?isAdd=true&key_re=$key&user_re=$nameString&name_re=$nameEqString&group_re=$group&type_re=$type&unit_re=$unit&total_re=$total&process_re=$process&status_re=$placeString&no_re=$noString&because_re=$becauseString&admin_re=$loginString';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (BuildContext context) => Store(
            userAccoutModel: userAccoutModel,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      } else {
        normalAlert(context, 'ผิดพลาด', 'กรุณาลองใหม่');
      }
    } else {
      String url =
          'https://iot-en.me/api/addReportBoss.php?isAdd=true&key_re=$key&user_re=$nameString&name_re=$nameEqString&group_re=$group&type_re=$type&unit_re=$unit&total_re=$total&process_re=$process&status_re=$placeString&admin_re=$loginString';
      Response response = await get(url);
      var result = json.decode(response.body);
      if (result.toString() == 'true') {
        MaterialPageRoute materialPageRoute = MaterialPageRoute(
          builder: (BuildContext context) => Store(
            userAccoutModel: userAccoutModel,
          ),
        );
        Navigator.of(context).pushAndRemoveUntil(
            materialPageRoute, (Route<dynamic> route) => false);
      } else {
        normalAlert(context, 'ผิดพลาด', 'กรุณาลองใหม่');
      }
    }
  }

  Future<void> decreaseProcess() async {
    String currentTotal = myEquipmentModel.total;
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
        '\n ขณะนี้มีจำนวนต่ำกว่าที่กำหนดคือ ${myEquipmentModel.limit} \n\n ลงวันที่ : $realTime \n ชื่อ : ${myEquipmentModel.name} \n กลุ่ม : ${myEquipmentModel.group} \n ประเภท : ${myEquipmentModel.type} \n จำนวนคงเหลือ : ${totalAInt} ${myEquipmentModel.unit}';
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
          "Authorization": "Bearer zWNuebTnP963lVr9LZTdWmMkVXvnKZOrEmm4jps9jtz",
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

  // Widget testLine() {
  //   return IconButton(
  //     icon: Icon(Icons.android),
  //     onPressed: () {
  //       callLineAPI();
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          levelString == '1' ? barDeleteEquipment() : SizedBox(),
          levelString == '1' ? barEditEquipment() : SizedBox(),
        ],
        // actions: <Widget>[testLine()],
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
                myGroup(),
                Divider(),
                myType(),
                Divider(),
                showName(),
                Divider(),
                myTotal(),
              ],
            ),
          ),
          levelString == '1' ? adminButton() : SizedBox(),
          levelString == '11' ? miniAdminButton() : SizedBox(),
          levelString == '12' ? userButton() : SizedBox(),
        ],
      ),
    );
  }
}
