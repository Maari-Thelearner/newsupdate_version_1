import 'dart:async';
import 'package:covidandnewsupdate/covid/dashboard.dart';
import 'package:covidandnewsupdate/covid/global.dart';
import 'package:covidandnewsupdate/theme.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';

import 'countries.dart';
void main()=>
runApp(Myapp());
class Myapp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_)=>ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) {
          return      MaterialApp(
            title: 'NewsUpdate',
            theme: notifier.darkTheme ? dark : light,
            debugShowCheckedModeBanner: false,
            home: menu(),
          );
        } ,
      ),
    );
  }
}
class menu extends StatefulWidget {
  @override
  _menuState createState() => _menuState();
}

class _menuState extends State<menu> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 74, vsync: this )..addListener(() {
      setState(() {

      });
    });
  }
var _defaultCountrycode='in';
  final Completer<WebViewController> _completer= Completer<WebViewController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('News',style: TextStyle(color: Colors.black87),),
            Text('Update',style: TextStyle(color: Colors.white),)  ,
          ],
        ),
        elevation: 7.0,
        backgroundColor: Colors.deepOrange,
      ),
      drawer: Drawer(
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
         child: Image.network('https://img.etimg.com/thumb/msid-74930234,width-640,resizemode-4,imgsize-243717/coronavirus-and-covid-19.jpg'),
       ),

            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0 , 0 , 10.0 , 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: InkWell(
                  splashColor: Colors.blue[900],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Global();
                    }),);
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.public,color: Colors.blue[900],),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Global COVID Update",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.blue) ),
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
                  splashColor: Colors.orange[900],
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Dashboard();
                    }),);
                  },
                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.public,color: Colors.orange[900],),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("India COVID Update",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.orange) ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Consumer<ThemeNotifier>(
              builder: (context,notifier,child) => SwitchListTile(
                title: Text("Dark Mode"),
                onChanged: (val){
                  notifier.toggleTheme();
                },
                value: notifier.darkTheme ,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0 , 250.0 , 10.0 , 8.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.grey)),
                ),
                child: InkWell(
                  splashColor: Colors.green[900],
                  onTap: () async {
                    var countrycode = await Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Country();
                    }),);
                    if(countrycode.toString().isNotEmpty) {
                      setState(() {
                        _defaultCountrycode = countrycode;
                      });
                    }
                  },

                  child: Container(
                    height: 50,
                    child: Row(
                      children: [
                        Icon(Icons.language,color: Colors.green [900],),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Change Countries",style : TextStyle(fontSize: 25.0,fontWeight: FontWeight.bold,color: Colors.green[400]) ),
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
                child: Text('To click the change countries button and then you are able to change the Countries',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),


          ],
        ),
      ),
      body: Column(
        children:[
          Expanded(
            flex: 1,
            child: Center(child: Text('News Headlines',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30.0),)),),
          Expanded(
            flex: 9,
              child: FutureBuilder(
                future: http.get('http://newsapi.org/v2/top-headlines?country=$_defaultCountrycode&category=business&apiKey=50cd87a239064bb39c8d5c4343253080'),
                builder: (context,newsData) => newsData.connectionState == ConnectionState.waiting ?
                Center(
                  child: CircularProgressIndicator(),
                )
                    : ListView.builder(
                  itemCount: json.decode(newsData.data.body)['articles'].length,
                  itemBuilder: (context,index) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: GestureDetector(
                        onTap: () {
                          var url=json.decode(newsData.data.body)['articles'][index]['url'];
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return Scaffold(
                              appBar: AppBar(title: Text('news data'),
                              actions: [
                                IconButton(icon: Icon(Icons.backspace_outlined), onPressed: (){
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                    return menu();
                                  }));
                                })
                              ],
                              ),
                              body: WebView(
                                initialUrl: url,
                                javascriptMode: JavascriptMode.unrestricted,
                                onWebViewCreated: ((WebViewController webViewController){
                                  setState(() {
                                    _completer.complete(webViewController);
                                  });
                                }),

                              ),
                            );
                          }),);
                        },

                        child: Column(
                          children: [
                            Image.network(
                              json.decode(newsData.data.body)['articles'][index]
                              ['urlToImage'] ??
                                  "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/480px-No_image_available.svg.png",
                              loadingBuilder: (context , child, progress){
                                if(progress == null) return child;
                                return Container(
                                  height: 200,
                                  width: double.infinity,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                        value: progress.expectedTotalBytes != null
                                            ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes
                                            : null
                                    ),
                                  ),
                                );
                              },

                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Text(json.decode(newsData.data.body)['articles'][index]['title'],style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
                          ],
                        ),
                      ),
                    ),
                  ),

                ),
              ),
            ),
        ],
      ),

    );
  }
}
