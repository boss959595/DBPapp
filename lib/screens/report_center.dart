import 'dart:async';
import 'dart:convert';
import 'package:dbpapp/models/report_model.dart';
import 'package:dbpapp/screens/report_detail_center.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportCenter extends StatefulWidget {
  final ReportModel reportModel;
  ReportCenter({Key key, this.reportModel}) : super(key: key);

  @override
  _ReportCenterState createState() => _ReportCenterState();
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

class _ReportCenterState extends State<ReportCenter> {
  // Explicit
  ReportModel myReportModel;
  List<ReportModel> reportModels = [];
  List<ReportModel> filterReportModels = List();
  final debouncer = Debouncer(milliseconds: 500);
  final formKey = GlobalKey<FormState>();
  String userString;

  // Medthod
  @override
  void initState() {
    super.initState();
    setState(() {
      readAllDataReport();
      myReportModel = widget.reportModel;
      findUser();
    });
  }

  Future findUser() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    userString = sharedPreferences.getString('User');
    print(userString);
    //findLevel();
  }

  Widget searchTextReport() {
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
            filterReportModels = reportModels
                .where(
                  (u) => (u.dateEe.toLowerCase().contains(value.toLowerCase())),
                )
                .toList();
          });
          setState(() {
            filterReportModels = reportModels
                .where(
                  (u) => (u.nameRe.toLowerCase().contains(value.toLowerCase())),
                )
                .toList();
          });
        });
      },
    );
  }

  Future readAllDataReport() async {
    String url = 'http://androidthai.in.th/boss/getAllReportBoss.php';
    Response response = await get(url);
    var result = json.decode(response.body);
    print('All Report = $result');
    for (var map in result) {
      ReportModel reportModel = ReportModel.formJSON(map);
      print('Date = ${reportModel.dateEe}, Name = ${reportModel.nameRe}');
      setState(() {
        reportModels.add(reportModel);
        filterReportModels = reportModels;
      });
    }
  }

  Widget showDateReport(int index) {
    return Text(
      filterReportModels[index].dateEe,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.black,
      ),
    );
  }

  Widget showNameReport(int index) {
    return Text(
      filterReportModels[index].nameRe,
      style: TextStyle(
        fontSize: 15.0,
        color: Colors.orange,
      ),
    );
  }

  Widget showReportListView() {
    return Expanded(
      child: ListView.builder(
        itemCount: filterReportModels.length,
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
              print('You click ${filterReportModels[index].dateEe}');
              MaterialPageRoute materialPageRoute = MaterialPageRoute(
                  builder: (BuildContext context) => ShowReportDetailCenter(
                        reportModel: filterReportModels[index],
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
        backgroundColor: Colors.orange,
        title: Text(
          'ประวัติการทำรายการ',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(25, 5, 25, 5),
            child: searchTextReport(),
          ),
          showReportListView(),
        ],
      ),
    );
  }
}
