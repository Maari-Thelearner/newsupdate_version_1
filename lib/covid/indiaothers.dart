import 'dart:convert';
import 'package:covidandnewsupdate/covid/globaltoday.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Indiaother> insertData() async {
  final response = await http.get('https://corona.lmao.ninja/v2/countries/india?yesterday=false');
  if (response.statusCode == 200) {
    return Indiaother.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load Covid');
  }
}

class Indiaother {
  final int population;
  final int tests;
  final int updated;

  Indiaother({this.population, this.tests,  this.updated});
  factory Indiaother.fromJson(Map<String, dynamic> jsno) {
    return Indiaother(
      population: jsno['population'],
      tests: jsno['tests'],
      updated: jsno['updated'],
    );
  }
}
class Indiaothers extends StatefulWidget {
  @override
  _IndiaothersState createState() => _IndiaothersState();
}

class _IndiaothersState extends State<Indiaothers> {
  Future<Indiaother> futureCovid;
  @override
  void initState() {
    futureCovid = insertData();
    super.initState();
  }

  String _dataValue(int timeInMillis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat("dd-MM-yyyy hh:mm:ss").format(date);
    return formattedDate.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.orange,
        title: Text(
          'India Covid-19 Stats',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: FutureBuilder<Indiaother>(
        future: futureCovid,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  flex: 4,
                  child: Image.network('https://www.ft.com/__origami/service/image/v2/images/raw/https%3A%2F%2Fd1e00ek4ebabms.cloudfront.net%2Fproduction%2F549010eb-ecf2-4d81-ab79-52cb8c5d07cf.jpg?fit=scale-down&source=next&width=700'),
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
                            'Indian\nPopulation:',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            snapshot.data.population.toString(),
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
                            'Tests\nTill now : ',
                            style: TextStyle(
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          Text(
                            snapshot.data.tests.toString(),
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Designed by Maari\n LastUpdate : ${_dataValue(snapshot.data.updated)}',
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

