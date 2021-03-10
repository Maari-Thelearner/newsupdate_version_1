import 'dart:convert';
import 'indiaothers.dart';
import 'indiatoday.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<Covid> fetchData() async{
  final response = await http.get('https://corona.lmao.ninja/v2/countries/india?yesterday=false');
  if(response.statusCode == 200)
  {
    return Covid.fromJson(json.decode(response.body));
  }
  else
  {
    throw Exception('Failed to load Covid');
  }
}
class Covid{
  final int cases;
  final int deaths;
  final int recovered;
  final int active;
  final int updated;
  Covid({this.cases, this.deaths, this.recovered, this.active, this.updated});
  factory Covid.fromJson(Map<String,dynamic> jsno){
    return Covid(
        cases: jsno['cases'],
        deaths: jsno['deaths'],
        recovered: jsno['recovered'],
        active: jsno['active'],
        updated: jsno['updated']
    );
  }
}
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Future<Covid> futureCovid;
  @override
  void initState() {
    futureCovid=fetchData();
    super.initState();
  }
  String _dataValue(int timeInMillis)
  {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat("dd-MM-yyyy hh:mm:ss").format(date);
    return formattedDate.toString();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(child: Text('India Covid Update', style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),)),
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
                child :Image.network('https://img.etimg.com/thumb/msid-74930234,width-640,resizemode-4,imgsize-243717/coronavirus-and-covid-19.jpg')
              ),

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0 , 0 , 10.0 , 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: InkWell(
                  splashColor: Colors.orange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Indiatoday();
                    }),);
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.date_range),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Today Covid Update",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.orange) ),
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
                  splashColor: Colors.orange,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Indiaothers();
                    }),);
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.devices_other),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Others",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.orange) ),
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
      body: FutureBuilder<Covid>(
        future: futureCovid,
        builder: (context,snapshot){
          if(snapshot.hasData){
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
                      color: Colors.amber,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Cases : ',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text(snapshot.data.cases.toString(),
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                            'Active : ',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text(snapshot.data.active.toString(),
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                            'Recovered : ',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text(snapshot.data.recovered.toString(),
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                            'Deaths : ',style: TextStyle(fontSize: 30.0,fontWeight: FontWeight.bold,color: Colors.black),),
                          Text(snapshot.data.deaths.toString(),
                            style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
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
                    child: Row(
                      children: [
                        Text('Designed by Maari \n LastUpdate : ${_dataValue(snapshot.data.updated)}' ,
                          style: TextStyle(color: Colors.black, fontSize: 15.0 ,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          else if(snapshot.hasError){
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

