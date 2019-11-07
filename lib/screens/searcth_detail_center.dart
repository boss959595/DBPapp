import 'dart:convert';
import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/models/user_accout.dart';
import 'package:dbpapp/screens/my_dialog.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/search_center.dart';
import 'package:dbpapp/screens/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String xuserString,xlevelString = '',
      xkeyString,
      xnameString,
      xtypeString,
      xgroupString,
      xunitString,
      xlimitString;
   
  final formKey = GlobalKey<FormState>();
  UserAccoutModel userAccoutModel;

  // Method
  @override
  void initState() {
    super.initState();
    setState(() {
      myEquipmentModel = widget.equipmentModel;
      findUser();
    });
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
            titlePadding: EdgeInsets.fromLTRB(0.0, 3.0, 0.0, 3.0),
            contentPadding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 20.0),
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
            decoration: InputDecoration(
              labelText: 'ชื่อวัสดุหรืออุปกรณ์'sssss,
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
              xkeyString = value.trim();
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
              xnameString = value.trim();
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
              xtypeString = value.trim();
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
              xgroupString = value.trim();
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
              xunitString = value.trim();
            },
          ),
          SizedBox(
            height: 3.0,
          ),
          TextFormField(keyboardType: TextInputType.number,
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
    return FlatButton(
        child: Text('ตกลง'),
        onPressed: () {
          processOkDelete();
          Navigator.of(context).pop();
        });
  }

  Future<void> processOkDelete() async {
    String idDeleteEquipment = myEquipmentModel.idEq;
    int xidDeleteEquipment = int.parse(idDeleteEquipment);
    //print(idDeleteEquipment);

    String url = 'https://www.androidthai.in.th/boss/deleteEquipmentWhereIdBoss.php?isAdd=true&id_eq=$xidDeleteEquipment';
    await get(url);
    MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext context) => SearchCenter());
    Navigator.of(context).push(materialPageRoute);
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

  Widget okEditButton() {
    return FlatButton(
      child: Text('บันทึก'),
      onPressed: () {
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          //print('boss = $xkeyString, $xnameString, $xtypeString, $xgroupString, $xunitString, $xlimitString');
          editEquipment();
          Navigator.of(context).pop();
        }
      },
    );
  }

  Future<void> editEquipment()async{
    String idDeleteEquipment = myEquipmentModel.idEq;
    int xidDeleteEquipment = int.parse(idDeleteEquipment);
    int xxlimitString = int.parse(xlimitString);

     print('boss = $xidDeleteEquipment,$xkeyString, $xnameString, $xtypeString, $xgroupString, $xunitString, $xxlimitString');

   String url = 'https://www.androidthai.in.th/boss/editEquipmentWhereIdboss.php/?isAdd=true&id_eq=$xidDeleteEquipment&key=$xkeyString&name=$xnameString&type=$xtypeString&group=$xgroupString&unit=$xunitString&limit=$xxlimitString';

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
      normalAlert(context, 'ผิดพลาด', 'กรุณา กรอกค่าแจ้งเตือน มากกว่า 1 ขึ้นไป');
     }
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
        'https://www.androidthai.in.th/boss/updateEquipmentWhereIdboss.php?isAdd=true&id_eq=$ideq&total=$totalAInt';
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
        callLineAPI();
      }
      increaseAndDecreaseProcess('1');
      insertReport('1', totalAInt);
    }
  }

  Future<void> callLineAPI() async {
    String message =
        '      ชื่อ : ${myEquipmentModel.name} กลุ่ม : ${myEquipmentModel.group} ประเภท : ${myEquipmentModel.type} จำนวนคงเหลือ : ${myEquipmentModel.total} ${myEquipmentModel.unit}';

    String url = 'https://notify-api.line.me/api/notify?message=$message';
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Bearer s1mg5tgZjQICeHgjLSzGbG39kLbVAsDbTilYurdZ2W4"
    };
    String body = '{"message":"boss test"}';

    Response response = await post(url, headers: headers, body: body);
    int statusCode = response.statusCode;
    print('statusCode = $statusCode');
    String result = response.body;
    print(result);
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
