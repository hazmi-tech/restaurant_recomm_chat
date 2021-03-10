import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/register_page.dart';
import 'package:group_chat_app/pages/signin_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/forgotpass.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/shared/loading.dart';

import 'home_page.dart';


class authenticate_page extends StatefulWidget {
  @override
  AuthenticatePageState createState() {
    return AuthenticatePageState();
  }
}

class AuthenticatePageState extends State<authenticate_page> with SingleTickerProviderStateMixin {



  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _isLoading = false;


  // text field state
  String fullName = '';
  String email = '';
  String userCity = '';
  String password = '';
  String error = '';

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() async {
        _isLoading = true;
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));

      });
      await _auth.registerWithEmailAndPassword(fullName, email,userCity, password).then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserNameSharedPreference(fullName);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserCitySharedPreference(userCity);

          print("Registered");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });
          await HelperFunctions.getUserCitySharedPreference().then((value) {
            print("userCity: $value");
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        }
        else {
          setState(() {
            error = 'خطأ أثناء التسجيل!';
            _isLoading = false;
          });
        }
      }
      );

    }
  }

  _onSignIn() async {
    if (_formKey2.currentState.validate()) {
      setState(() {
        _isLoading = true;
      },

      );

      await _auth.signInWithEmailAndPassword(email, password).then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);

          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data['fullName']
          );
          await HelperFunctions.saveUserCitySharedPreference(
              userInfoSnapshot.documents[0].data['userCity']
          );
          await HelperFunctions.saveUserEmailSharedPreference(email);
          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });
          await HelperFunctions.getUserCitySharedPreference().then((value) {
            print("userCity: $value");
          });

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        }
        else {
          setState(() {
            error = 'خطأ أثناء التسجيل!';
            _isLoading = false;
          });
        }
      });
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
    }
  }



  bool isLogin = true;
  Animation<double> loginSize;
  AnimationController loginController;
  AnimatedOpacity opacityAnimation;
  Duration animationDuration = Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIOverlays([]);

    loginController =
        AnimationController(vsync: this, duration: animationDuration);

    opacityAnimation =
        AnimatedOpacity(opacity: 0.0, duration: animationDuration);
  }

  @override
  void dispose() {
    loginController.dispose();
    super.dispose();
  }

  Widget _buildLoginWidgets() {

    return Container(
      padding: EdgeInsets.only(bottom: 62, top: 16),
      width: MediaQuery.of(context).size.width,
      height: loginSize.value,
      decoration: BoxDecoration(
          color: Color(0xffff8046),
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(190),
              bottomRight: Radius.circular(190))),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedOpacity(
          opacity: loginController.value,
          duration: animationDuration,
          child: GestureDetector(
            onTap: isLogin ? null : () {
              loginController.reverse();

              setState(() {
                isLogin = !isLogin;
              });
            },
            child: Container(
              child: Text(
                'الدخول'.toUpperCase(),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginComponents() {
    return Form(
      key: _formKey2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Visibility(
            visible: isLogin,
            child: Padding(
              padding: const EdgeInsets.only(left: 42, right: 42, bottom: 16),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    style: TextStyle(color: Colors.white, height: 0.5),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'البريد الالكتروني',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32))
                        )
                    ),
                    validator: (val) {
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
                    },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),

                  Container(height: 8,),
                  TextFormField(
                    style: TextStyle(color: Colors.white, height: 0.5),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: 'كلمة المرور',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(32)))),
                    validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },

                  ),
                  Container(height: 2,),
                  FlatButton(
                    //color: Color(0xffff8046),
                    // padding: const EdgeInsets.only(top: 16),
                    onPressed: () {Navigator.of(context).pushReplacementNamed('/forgotpass');},
                    child: Text("نسيت كلمة المرور؟",
                      style: TextStyle(
                          color: Colors.white
                      ),

                    ),
                  ),

                  RaisedButton(
                    // width: 200,
                    //height: 40,
                    // margin: EdgeInsets.only(top: 32),
                    //decoration: BoxDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),


                      child:  Center(
                        child: Text(
                          'الدخول',
                          style: TextStyle(color: Color(0XFFFF0000000),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      onPressed: () {
                        _onSignIn();
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                      }
                  ),


                  Container(height: 12,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(

                          child:

                          SignInButton(

                            Buttons.Facebook,
                            mini: true,
                            onPressed: () {},
                          )
                      ),
                      Container(
                          child:
                          SignInButton(
                            Buttons.Twitter,
                            mini: true,
                            onPressed: () {},
                          )
                      ),
                    ],
                  ),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegistercomponents() {
    return Form(
      key: _formKey,
      child:  Padding(
        padding: EdgeInsets.only(
            left: 42,
            right: 42,
            top: 32,
            bottom: 32
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Text(
                'تسجيل جديد'.toUpperCase(),
                style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            TextFormField(
              style: TextStyle(color: Colors.black, height: 0.5),
              decoration: InputDecoration(
                  prefixIcon: Icon(
                    Icons.person,
                  ),
                  hintText: 'الاسم',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),

              onChanged: (val) {
                setState(() {
                  fullName = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child: TextFormField(
                style: TextStyle(color: Colors.black, height: 0.5),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.location_on_rounded),
                    hintText: 'المدينة',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)))),
               
               
                onChanged: (val) {
                  setState(() {
                    userCity = val;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: TextFormField(
                style: TextStyle(color: Colors.black, height: 0.5),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'البريد الالكتروني',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)))),
                validator: (val) {
                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "Please enter a valid email";
               },
                onChanged: (val) {
                  setState(() {
                    email = val;
                  });
                },

              ),
            ),
            TextFormField(
              style: TextStyle(color: Colors.black, height: 0.5),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  hintText: 'كلمة المرور',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
              validator: (val) => val.length < 6 ? 'Password not strong enough' : null,
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 24),

              child: RaisedButton(
                //width: 200,
                // height: 40,
                //  margin: EdgeInsets.only(top: 32),
                //  decoration: BoxDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                  color: Color(0xffff8046),
                  // borderRadius: BorderRadius.all(Radius.circular(50))
                  child: Center(
                    child: Text(
                      'تسجيل جديد',
                      style: TextStyle(color: Colors.white,
                          fontWeight: FontWeight.bold
                      ),

                    ),

                  ),
                  onPressed: () {
                    _onRegister();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
                  }
              ) ,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double _defaultLoginSize = MediaQuery.of(context).size.height / 1.6;

    loginSize = Tween<double>(begin: _defaultLoginSize, end: 200).animate(
        CurvedAnimation(parent: loginController, curve: Curves.linear));

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedOpacity(
              opacity: isLogin ? 0.0 : 1.0,
              duration: animationDuration,
              child: Container(child: _buildRegistercomponents()),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: isLogin && !loginController.isAnimating ? Colors.white : Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: _defaultLoginSize/1.5,
              child: Visibility(
                visible: isLogin,
                child: GestureDetector(
                  onTap: () {
                    loginController.forward();
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                  child: Center(
                    child: Text(
                      'تسجيل جديد'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color:new Color(0xffff8046),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: loginController,
            builder: (context, child) {
              return _buildLoginWidgets();
            },
          ),
          Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height/2,
                child: Center(child: _buildLoginComponents()),
              )
          )
        ],
      ),
    );
  }

}
