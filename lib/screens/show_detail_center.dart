import 'package:dbpapp/models/equipment_model.dart';
import 'package:dbpapp/screens/my_style.dart';
import 'package:flutter/material.dart';

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

  // Method
  @override
  void initState() {
    super.initState();
    setState(() {
      myEquipmentModel = widget.equipmentModel;
    });
  }

  Widget showName() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text('ชื่อ : ${myEquipmentModel.name}'),
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
    return Text('กลุ่ม : ${myEquipmentModel.group}');
  }

  Widget myType() {
    return Text('ประเภท : ${myEquipmentModel.type}');
  }

  Widget myTotal() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'จำนวนคงเหลือ : ${myEquipmentModel.total} ${myEquipmentModel.unit}',
          style: TextStyle(fontSize: MyStyle().h2),
        ),
      ],
    );
  }

  Widget myButton() {
    return Column(mainAxisAlignment: MainAxisAlignment.end,
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
          child: RaisedButton.icon(color: Colors.lightGreen,
        icon: Icon(Icons.add_shopping_cart),
        label: Text('เพิ่ม' ,style: TextStyle(color: Colors.black),),
        onPressed: () {},
      ),
    );
  }

  Widget decreaseButton() {
    return Expanded(
          child: RaisedButton.icon(color: Colors.red.shade500,
        icon: Icon(Icons.remove_shopping_cart),
        label: Text('ลด'),
        onPressed: () {},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายละเอียด'),
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
          myButton(),
        ],
      ),
    );
  }
}