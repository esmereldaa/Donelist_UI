import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_donelist/model/getDataModel.dart';
import 'package:project_donelist/service/apiService.dart';
import 'package:project_donelist/ui/inputPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.token}) : super(key: key);
  final String token;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ApiService _apiService = new ApiService();
  List<DataUser> listOfData;
  List<Value> listOfDataValue;
  String uname = "";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text("Home"),
            automaticallyImplyLeading: false,
            actions: [
              Padding(
                  padding: EdgeInsets.all(2),
                  child: GestureDetector(
                    child: Icon(Icons.logout),
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.clear();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => LandingPage()),
                          (Route<dynamic> route) => false);
                    },
                  ))
            ],
          ),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                width: size.width,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                  color: const Color(0xff5b66ff),
                ),
                child: FutureBuilder<List<DataUser>>(
                  future: _apiService.getUser(widget.token),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<DataUser>> snapshot) {
                    if (snapshot.hasData) {
                      List<DataUser> posts = snapshot.data;
                      listOfData = posts;
                      uname = posts[0].uname;
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Hi, " + posts[0].uname + " !",
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 30,
                              color: const Color(0xfffffbfb),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          Text(
                            "Activity Done",
                            style: TextStyle(
                              fontFamily: 'Arial',
                              fontSize: 24,
                              color: const Color(0xfffffbfb),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.left,
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Text("Loading");
                  },
                ),
              ),
              Container(
                // margin: EdgeInsets.only(top: size.height * 0.3),
                child: FutureBuilder<List<Value>>(
                  future: _apiService.getPosts(widget.token),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Value>> snapshot) {
                    if (snapshot.hasData) {
                      List<Value> datas = snapshot.data;
                      listOfDataValue = datas;
                      return ListView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        children: datas
                            .map((Value data) => Card(
                                elevation: 1,
                                child: ListTile(
                                  title: Text(data.taskData),
                                  subtitle: Text(
                                      data.date.toString().substring(0, 10)),
                                )))
                            .toList(),
                      );
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Text("No Activity");
                  },
                ),
              )
            ],
          )),
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xff5b66ff),
            foregroundColor: Colors.white,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => InputPage(
                        token: widget.token,
                        uname: uname,
                      )),
            ),
            child: Icon(Icons.add),
          ),
        ),
        onWillPop: () {
          return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Exit"),
                  content: Text("Are you sure you want to exit?"),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("YES"),
                      onPressed: () {
                        SystemNavigator.pop();
                      },
                    ),
                    FlatButton(
                      child: Text("NO"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        });
  }
}
