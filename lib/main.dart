import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/services.dart' ;
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_chat_app/pages/intro_slider.dart';
import 'package:group_chat_app/pages/splash_screen.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/pages/All_consultaions.dart';



void main() => runApp(  DevicePreview(
    enabled: true,
    builder: (context) => MyApp(), // Wrap your app
  ),
  );

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
      title: 'ايش ناكل؟',
      debugShowCheckedModeBanner: false,
      locale: DevicePreview.locale(context), // Add the locale here
      builder: DevicePreview.appBuilder, 
   theme: ThemeData(
    textTheme: GoogleFonts.tajawalTextTheme(
      Theme.of(context).textTheme,
    ),
  ),
        //home: _isLoggedIn != null ? _isLoggedIn ? HomePage() : AuthenticatePage() : Center(child: CircularProgressIndicator()),
      home: _isLoggedIn ? HomePage(): SplashScreen(_isLoggedIn),
      //home: HomePage(),
    );
  }
}
 
