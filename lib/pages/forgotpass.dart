import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'home_page.dart';

void main() => runApp(forgotpass());

class forgotpass extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'forgot password',
      home: forgotpassPage(),
    );
  }
}

class forgotpassPage extends StatefulWidget {
  @override
  forgotpassPageState createState() {
    return forgotpassPageState();
  }
}

class forgotpassPageState extends State<forgotpassPage>
    with SingleTickerProviderStateMixin {
  String email = '';
  String password = '';
  bool isLogin = true;
  Animation<double> loginSize;
  AnimationController loginController;
  AnimatedOpacity opacityAnimation;
  Duration animationDuration = Duration(milliseconds: 270);

  //@override
  //Future<void> resetPassword(String email) async {
 //   await _firebaseAuth.sendPasswordResetEmail(email: email);
  //}
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

  Widget _buildWidgets() {
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
                ''.toUpperCase(),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[

      ],
    );
  }

  Widget _buildreset() {
    return Padding(
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
              'استعادة كلمة المرور'.toUpperCase(),
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),

          
            //padding: const EdgeInsets.only(bottom: 16, top: 16),
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
          

          Padding(
            padding: const EdgeInsets.only(top: 24),
    child: RaisedButton(
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
    'ارسال',
    style: TextStyle(color: Color(0XFFFF0000000),
    fontWeight: FontWeight.bold
    ),
    ),
    ),

    onPressed: () async {
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
        Navigator.of(context).pop();
      
    },
    ),
          )
        ],
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
              child: Container(child: _buildreset()),
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
                      'استعادة كلمة المرور'.toUpperCase(),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: new Color(0xffff8046),
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
              return _buildWidgets();
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
