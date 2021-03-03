import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:group_chat_app/pages/intro_slider.dart';
import 'package:group_chat_app/pages/home_page.dart';

class SplashScreen extends StatefulWidget {
  final bool _logeddIn;
  SplashScreen(this._logeddIn); 
  final Color backgroundColor = new Color(0xFFF48858);
  final TextStyle styleTextUnderTheLoader = TextStyle(
      fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
     bool  isloggedin= widget._logeddIn;
    if( !isloggedin)
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => Introduction()));
    else
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
       color: new Color(0xFFFF8046)
,
      child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 7,
                  child: Container(
                    color:new Color(0xFFFF8046)
,
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/rest-log-wh.jpeg',
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
                      CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)
                      ),
                      Container(
                        color: new Color(0xFFFF8046)
,
                        height: 10,
                      ),
                      
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  }
}