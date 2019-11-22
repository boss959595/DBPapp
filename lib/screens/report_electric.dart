import 'dart:async';
import 'dart:convert';
import 'package:dbpapp/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'report_detail_electric.dart';

class ReportElectric extends StatefulWidget {
  final ReportElectricModel reportElectricModel;
  ReportElectric({Key key,this.reportElectricModel}):super(key:key);
  @override
  _ReportElectricState createState() => _ReportElectricState();
}

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _time;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (null != _time) {
      _time.cancel();
    }
    _time = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class _ReportElectricState extends State<ReportElectric> {
 
// Explicit
ReportElectricModel myReportElectric;
List<ReportElectricModel> reportElectricModels=[];
List<ReportElectricModel> filterReportElectricModels=[];
final debouncer = Debouncer(milliseconds: 500);
final formKey = GlobalKey<FormState>();
String userString;


// Medthod
@override
  void initState() {
    super.initState();
    setState(() {
      readAllDataReport();
      myReportElectric=widget.reportElectricModel;
      findUser();
    });
  }
 
  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
    //findLevel();
  }

  Future readAllDataReport() async {
    String url = 'https://iot-en.me/api/getAllReportElectric.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('All Report = $result');
    for (var map in result) {
      ReportElectricModel reportElectricModel = ReportElectricModel.formJSON(map);
      setState(() {
        reportElectricModels.add(reportElectricModel);
        filterReportElectricModels = reportElectricModels;
      });
    }
  }

  Widget searchTextReportDate() {
    return Container(
      width: 175.0,
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade600),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(Icons.search),
          hintText: 'ค้นหาตามวันที่',
        ),
        onChanged: (value) {
          debouncer.run(() {
            setState(() {
              filterReportElectricModels = reportElectricModels
                  .where(
                    (u) =>
                        (u.dateRpEe.toLowerCase().contains(value.toLowerCase())),
                  )
                  .toList();
            });
            // setState(() {
            //   filterReportModels = reportModels
            //       .where(
            //         (u) => (u.nameRe.toLowerCase().contains(value.toLowerCase())),
            //       )
            //       .toList();
            // });
          });
        },
      ),
    );
  }

  Widget searchTextReportName() {
    return Container(
      width: 175.0,
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow.shade600),
            borderRadius: BorderRadius.circular(10.0),
          ),
          prefixIcon: Icon(Icons.search),
          hintText: 'ค้นหาตามขนาด Motor',
        ),
        onChanged: (value) {
          debouncer.run(() {
            // setState(() {
            //   filterReportModels = reportModels
            //       .where(
            //         (u) => (u.dateEe.toLowerCase().contains(value.toLowerCase())),
            //       )
            //       .toList();
            // });
            setState(() {
              filterReportElectricModels = reportElectricModels
                  .where(
                    (u) =>
                        (u.sizeRpEe.toLowerCase().contains(value.toLowerCase())),
                  )
                  .toList();
            });
          });
        },
      ),
    );
  }
 
 
  Widget showDateReport(int index) {
    return Text(
      filterReportElectricModels[index].dateRpEe,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
      ),
    );
  }

  Widget showNameReport(int index) {
    return Text(
      filterReportElectricModels[index].sizeRpEe,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.orange,
      ),
    );
  }

  Widget showReportListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: filterReportElectricModels.length,
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
                      child: Row(
                        children: <Widget>[
                          showDateReport(index),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.blue[600],
                    ),
                    Container(
                      width: 158,
                      child: Wrap(
                        children: <Widget>[
                          showNameReport(index),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            onTap: () {
              print('You click ${filterReportElectricModels[index].dateRpEe}');
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => ReportDetailElectric(
                        reportElectricModel: filterReportElectricModels[index],
                      ));
              Navigator.of(context).push(materialPageRoute);
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconTheme.of(context),
        backgroundColor: Colors.yellowAccent,
        title: Text(
          'ประวัติการทำรายการ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(padding: EdgeInsets.fromLTRB(3.0, 10.0, 1.0, 5.0),
            child: Row(
              children: <Widget>[
                searchTextReportDate(),
                SizedBox(
                  width: 5.0,
                ),
                searchTextReportName()
              ],
            ),
          ),

          // Container(
          //   padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
          //   child: searchTextReportDate(),
          // ),
          // Container(
          //   padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
          //   child: searchTextReportName(),
          // ),

          showReportListView(),
        ],
      ),
    );
  }
}
