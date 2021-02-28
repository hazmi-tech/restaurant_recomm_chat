import 'dart:async';
import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/intro_slider.dart';
import 'package:intro_slider/intro_slider.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor = new Color(0xFFF48858);
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String _versionName = 'V1.0';
  final splashDelay = 5;

  @override
  void initState() {
    super.initState();

    _loadWidget();
  }

  _loadWidget() async {
    var _duration = Duration(seconds: splashDelay);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Introduction()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
       color: new Color(0xFFF48858),
      child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    color: new Color(0xFFF48858),
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/rest-log-wh.PNG',
                        height: 300,
                        width: 300,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                      ),
                    ],
                  )),
                ),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      CircularProgressIndicator(),
                      Container(
                        color: new Color(0xFFF48858),
                        height: 10,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}