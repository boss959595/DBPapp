import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:dbpapp/screens/search_add_equiment_center.dart';
import 'package:dbpapp/screens/searcth_detail_center.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:async';

class SearchCenter extends StatefulWidget {
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
  List<EquipmentModel> equipmentModels = [];
  List<EquipmentModel> filterEquipmentModels = List();
  final debouncer = Debouncer(milliseconds: 500);
  final formKey = GlobalKey<FormState>();

    String userString, levelString = '', numberString, nameString;

  String arrowR1 = 'images/right1.png';
  String arrowR2 = 'images/right2.png';

  // Method
  @override
  void initState() {
    super.initState();
    readAllData();
  }

  Future<void> readAllData() async {
    String url = 'https://www.androidthai.in.th/boss/getAllEquipmentMaster.php';
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
                padding: EdgeInsets.fromLTRB(5.0, 3.0, 5.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    showName(index),
                    showTotal(index),
                  ],
                ),
              ),
            ),
            onTap: () {
              // print('You click ${filterEquipmentModels[index].name}');
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
        showEditEquipment();

      },
    );
  }

  void showEditEquipment(){
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.fromLTRB(0.0, 5.0, 5.0, 0.0),
            contentPadding: EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 0.0),
            title: Text('เพิ่มวัดุหรืออุปกรณ์'),
            content: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: showEditEquipment1(),
            ),
            actions: <Widget>[
              // okButton(),
              // cancelButton(),
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

  Widget headColumn() {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 3.0, 5.0, 5.0),
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
        actions: <Widget>[addEquipment()],
        iconTheme: IconTheme.of(context),
        backgroundColor: Colors.orange,
        title: Text(
          'วัสดุ และ อุปกรณ์ คลังกลาง',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
            child: searchText(),
          ),
          headColumn(),
          showListView(),
        ],
      ),
    );
  }
}
