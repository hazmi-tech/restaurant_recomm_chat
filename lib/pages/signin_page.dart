import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/shared/constants.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:group_chat_app/shared/loading.dart';

class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(email, password).then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot = await DatabaseService().getUserData(email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
            userInfoSnapshot.documents[0].data['fullName']
          );

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

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        }
        else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading ? Loading() : Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          color: Colors.white,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text("ايش ناكل؟", style: TextStyle(color: new Color(0xFFFF8046), fontSize: 40.0, fontWeight: FontWeight.bold)),
                
                  SizedBox(height: 30.0),
                
                  Text("تسجيل الدخول", style: TextStyle(color: new Color(0xFFFF8046), fontSize: 25.0)),

                  SizedBox(height: 20.0),
                  TextFormField(
                  style: TextStyle(color: Colors.black, height: 0.5),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'البريد الالكتروني',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(32))
                            
                        )
                    ),
                    validator: (val) {
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null : "من فضلك أدخل بريد الكتروني صحيح";
                    },
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),

                  Container(height: 8,),
                  TextFormField(
                    style: TextStyle(color: Colors.black, height: 0.5),
                    decoration: InputDecoration(
                        prefixIcon: Icon(Icons.vpn_key),
                        hintText: 'كلمة المرور',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                                Radius.circular(32)))),
                    validator: (val) => val.length < 6 ? 'كلمة المرور يجب أن تكون أطول من 6 أحرف' : null,
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },

                  ),
                  SizedBox(height: 20.0),
                
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.yellow[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('سجل الدخول', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        _onSignIn();
                      }
                    ),
                  ),
                
                  SizedBox(height: 10.0),
                  
                  Text.rich(
                    TextSpan(
                      text: "ليس لديك حساب؟ ",
                      style: TextStyle(color:  Colors.grey[700], fontSize: 14.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'سجل من هنا',
                          style: TextStyle(
                            color:  Colors.grey[700],
                            decoration: TextDecoration.underline
                          ),
                          recognizer: TapGestureRecognizer()..onTap = () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ),
                
                  SizedBox(height: 10.0),
                
                  Text(error, style: TextStyle(color: Colors.red, fontSize: 14.0)),
                ],
              ),

              
                  
                    Text(

                       "أو سجل باستخدام: ",
                       textAlign: TextAlign.center,
                       textDirection: TextDirection.rtl,
                      style: TextStyle(color:  Colors.grey[700], fontSize: 14.0)
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
      )
    );
  }
}
