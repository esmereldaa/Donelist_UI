import 'dart:async';

import 'package:flutter/material.dart';
import 'package:project_donelist/ui/daftarPage.dart';
import 'package:project_donelist/ui/homePage.dart';
import 'package:project_donelist/ui/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LandingPage());
  }
}

class LandingPage extends StatefulWidget {
  LandingPage({Key key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  String token1st = "false";

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () => {_panggilToken()});
  }

  _panggilToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var _ambiltext = prefs.getString('tokenSaved');
    print("start app");
    if (_ambiltext != null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) => HomePage(
                    token: _ambiltext,
                  )),
          (Route<dynamic> route) => false);
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MaterialButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    ),
                child: Container(
                  margin: EdgeInsets.all(20),
                  width: size.width * 0.8,
                  height: size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff5b66ff),
                  ),
                  child: Center(
                      child: Text(
                    'LOGIN',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 20,
                      color: const Color(0xfffffbfb),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  )),
                )),
            MaterialButton(
                onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DaftarPage()),
                    ),
                child: Container(
                  width: size.width * 0.8,
                  height: size.height * 0.1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xff5b66ff),
                  ),
                  child: Center(
                      child: Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 20,
                      color: const Color(0xfffffbfb),
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.left,
                  )),
                )),
          ],
        ),
      ),
    );
  }
}
