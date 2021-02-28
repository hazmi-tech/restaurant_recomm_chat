import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:group_chat_app/pages/forgotpass.dart';
//import 'package:flutter_signin_button/flutter_signin_button.dart';


class AuthenticatePage extends StatefulWidget {
  @override
  _AuthenticatePageState createState() => _AuthenticatePageState();
}

class _AuthenticatePageState extends State<AuthenticatePage>  with SingleTickerProviderStateMixin{

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Visibility(
          visible: isLogin,
          child: Padding(
            padding: const EdgeInsets.only(left: 42, right: 42),
            child: Column(
              children: <Widget>[
                TextField(
                  style: TextStyle(color: Colors.white, height: 0.5),
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: 'البريد الالكتروني',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(32))
                      )
                  ),
                ),

                  RaisedButton(
                    padding: const EdgeInsets.only(top: 16),
                    onPressed: () {Navigator.of(context).pushReplacementNamed('/forgotpass');},
                    child: TextField(
                    style: TextStyle(color: Colors.white, height: 0.5),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: 'كلمة المرور',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(32)))),
                  ),
                ),
                Container(height: 8,),
                Text("نسيت كلمة المرور؟",
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),


                Container(
                  width: 200,
                  height: 40,
                  margin: EdgeInsets.only(top: 32),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(50))
                  ),
                  child: Center(
                    child: Text(
                      'الدخول',
                      style: TextStyle(color: Color(0XFFFF0000000),
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
/** 
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
                    */
              ],

            ),
            
          ),
        ),

      ],
    );
  }

  Widget _buildRegistercomponents() {
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
              'تسجيل جديد'.toUpperCase(),
              style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black, height: 0.5),
            decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.person,
                ),
                hintText: 'الاسم',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)))),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 16),
            child: TextField(
              style: TextStyle(color: Colors.black, height: 0.5),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.location_on_rounded),
                  hintText: 'المدينة',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16, top: 8),
            child: TextField(
              style: TextStyle(color: Colors.black, height: 0.5),
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  hintText: 'الايميل',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(32)))),
            ),
          ),
          TextField(
            style: TextStyle(color: Colors.black, height: 0.5),
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                hintText: 'كلمة المرور',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(32)))),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Container(
              width: 200,
              height: 40,
              margin: EdgeInsets.only(top: 32),
              decoration: BoxDecoration(
                  color: Color(0xffff8046),
                  borderRadius: BorderRadius.all(Radius.circular(50))
              ),
              child: Center(
                child: Text(
                  'تسجيل جديد',
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ) ,
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

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }


