import 'dart:convert';

import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/screens/searcth_detail_center.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'my_style.dart';

class AlertLimitCenter extends StatefulWidget {
  final EquipmentModel equipmentModel;
  AlertLimitCenter({Key key, this.equipmentModel}) : super(key: key);

  @override
  _AlertLimitCenterState createState() => _AlertLimitCenterState();
}

class _AlertLimitCenterState extends State<AlertLimitCenter> {
  // Explicit
  List<EquipmentModel> equipmentModels = [];
  List<EquipmentModel> filterEquipmentModels = List();

  // Medthod
  @override
  void initState(){
    super.initState();
    setState(() {
     readAllAlertLimit(); 
    });
  }

  Future<void> readAllAlertLimit()async{
    String url = 'https://iot-en.me/api/getAlertLimitBoss.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('Alert = $result');

    for (var map in result) {
      EquipmentModel equipmentModel = EquipmentModel.formJSON(map);
      print('name = ${equipmentModel.name},${equipmentModel.limit},${equipmentModel.total}');
      setState(() {
       equipmentModels.add(equipmentModel);
       filterEquipmentModels = equipmentModels; 
      });
    }
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
              print('You click ${filterEquipmentModels[index].name}');
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
      filterEquipmentModels[index].name, textAlign: TextAlign.left,
      style: TextStyle(
        fontSize: MyStyle().h2,
        color: Colors.orange,
      ),
    );
  }

  Widget showLimit(int index) {
    return Text(
      filterEquipmentModels[index].limit,
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
        backgroundColor: Colors.orange,
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
