import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/screens/search_detail_electric.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'my_style.dart';

class AlertLimitElectric extends StatefulWidget {
  final EquipmentElectricModel equipmentElectricModel;
  AlertLimitElectric({Key key,this.equipmentElectricModel}):super(key:key);

  @override
  _AlertLimitElectricState createState() => _AlertLimitElectricState();
}

class _AlertLimitElectricState extends State<AlertLimitElectric> {
  // Explicit
  List<EquipmentElectricModel> equipmentElectricModels=[];
  List<EquipmentElectricModel> filterEquipmentElectricModels=[];

  // Medthod
  @override
  void initState() {
    super.initState();
    setState(() {
      readAllAlertLimit();
    });
  }
  
  Future<void> readAllAlertLimit()async{
    String url = 'https://iot-en.me/api/getAlertLimitElectric.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('Alert = $result');

    for (var map in result) {
      EquipmentElectricModel equipmentElectricModel = EquipmentElectricModel.formJSON(map);
      print('name = ${equipmentElectricModel.sizeEqEe},${equipmentElectricModel.limitEqEe},${equipmentElectricModel.totalEqEe}');
      setState(() {
       equipmentElectricModels.add(equipmentElectricModel);
       filterEquipmentElectricModels = equipmentElectricModels; 
      });
    }
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
              print('You click ${filterEquipmentElectricModels[index].sizeEqEe}');
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => ShowDetailElectric(
                        equipmentElectricModel: filterEquipmentElectricModels[index],
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
      filterEquipmentElectricModels[index].sizeEqEe, textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: MyStyle().h2,
        color: Colors.orange,
      ),
    );
  }

  Widget showLimit(int index) {
    return Text(
      filterEquipmentElectricModels[index].limitEqEe,
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
            'คงเหลือ',
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
      appBar: AppBar(iconTheme: IconTheme.of(context),
        backgroundColor: Colors.yellowAccent,
        title: Text(
          'รายการที่เหลือน้อยกว่ากำหนด',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
        ),
        headColumn(),
        showListView(),
      ],
      ),
    );
  }
}
