import 'dart:convert';

import 'package:covidandnewsupdate/covid/globalothers.dart';
import 'package:covidandnewsupdate/covid/globaltoday.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Globalcovid> fetchData() async {
  final response = await http.get('https://disease.sh/v3/covid-19/all');
  if (response.statusCode == 200) {
    return Globalcovid.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Covid');
  }
}

class Globalcovid {
  final int cases;
  final int deaths;
  final int recovered;
  final int active;
  final int updated;
  Globalcovid(
      {this.cases, this.deaths, this.recovered, this.active, this.updated});
  factory Globalcovid.fromJson(Map<String, dynamic> jsno) {
    return Globalcovid(
      cases: jsno['cases'],
      deaths: jsno['deaths'],
      recovered: jsno['recovered'],
      active: jsno['active'],
      updated: jsno['updated'],
    );
  }
}

class Global extends StatefulWidget {
  @override
  _GlobalState createState() => _GlobalState();
}

class _GlobalState extends State<Global> {
  Future<Globalcovid> futureCovid;
  @override
  void initState() {
    futureCovid = fetchData();
    super.initState();
  }

  String _dataValue(int timeInMillis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat("dd-MM-yyyy hh:mm:ss").format(date);
    return formattedDate.toString();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.blue,
        title: Text(
          'Global Covid Update',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      endDrawer: Drawer(
        elevation: 16.0,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  Colors.red,
                  Colors.black,
                ],),
              ),
              child: CircleAvatar(
                child : Image.network('https://img.etimg.com/thumb/msid-74930234,width-640,resizemode-4,imgsize-243717/coronavirus-and-covid-19.jpg'),
              ),

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0 , 0 , 10.0 , 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Globaltoday();
                    }),);
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.date_range),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Today Covid Update",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.blue) ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0 , 0 , 10.0 , 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: InkWell(
                  splashColor: Colors.blue,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Globalothers();
                    }),);
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.devices_other),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Others",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.blue) ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<Globalcovid>(
        future: futureCovid,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    color: Colors.blue,
                    child: Row(
                      children: [
                        Center(
                            child: Text(
                              "Total COVID Update",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  letterSpacing: 12.0),
                            )),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.amber,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Cases : ',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            snapshot.data.cases.toString(),
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.yellow,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Active : ',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            snapshot.data.active.toString(),
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.green,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Recovered : ',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            snapshot.data.recovered.toString(),
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.red,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Deaths : ',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            snapshot.data.deaths.toString(),
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Designed by Maari \n LastUpdate : ${_dataValue(snapshot.data.updated)}',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

