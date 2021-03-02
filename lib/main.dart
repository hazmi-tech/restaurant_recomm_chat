import 'package:flutter/material.dart';
import 'package:flutter/services.dart' ;
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_chat_app/pages/intro_slider.dart';
import 'package:group_chat_app/pages/splash_screen.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/pages/All_consultaions.dart';



void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _getUserLoggedInStatus();
  }

  _getUserLoggedInStatus() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
      if(value != null) {
        setState(() {
          _isLoggedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
    return MaterialApp(
      title: 'Group Chats',
      debugShowCheckedModeBanner: false,
   theme: ThemeData(
    textTheme: GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    ),
  ),
      darkTheme: ThemeData.dark(),
      //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),
      home: _isLoggedIn ? HomePage():  SplashScreen(_isLoggedIn),
      //home: HomePage(),
    );
  }
}
 
