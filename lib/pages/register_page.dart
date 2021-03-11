import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/shared/constants.dart';
import 'package:group_chat_app/shared/loading.dart';

class RegisterPage extends StatefulWidget {
  final Function toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String fullName = '';
  String email = '';
  String password = '';
  String error = '';

  String userCity;

  _onRegister() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth.registerWithEmailAndPassword(fullName, email, password ,userCity).then((result) async {
        if (result != null) {
          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(fullName);

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

          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
        }
        else {
          setState(() {
            error = 'Error while registering the user!';
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
          color:Colors.white,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
       Text("ايش ناكل؟", style: TextStyle(color: new Color(0xFFFF8046), fontSize: 40.0, fontWeight: FontWeight.bold)),
                
                  SizedBox(height: 30.0),
                
                  Text("التسجيل", style: TextStyle(color: new Color(0xFFFF8046), fontSize: 25.0)),

                  SizedBox(height: 20.0),
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
              padding: const EdgeInsets.only(bottom: 16, top: 8),
              child: TextFormField(
                style: TextStyle(color: Colors.black, height: 0.5),
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'البريد الالكتروني',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(32)))),
                validator: (val) {
                  return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val) ? null :"من فضلك أدخل بريد الكتروني صحيح";
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
              validator: (val) => val.length < 6 ? 'كلمة المرور يجب أن تكون أطول من 6 أحرف'  : null,
              obscureText: true,
              onChanged: (val) {
                setState(() {
                  password = val;
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 16),
              child:DropdownButton<String>(
                      isExpanded: true,
            hint: Text("اختر مدينتك",
                      textAlign: TextAlign.start,),
            value: userCity,
            //elevation: 5,
            style: TextStyle(color: Colors.black
            ),
            items: <String>[
              'جدة',
              'الرياض',
              'مكة',
              'المدينة',
              'أبها',
              'الطايف',
              'ينبع',
              'الدمام',
              "الأحساء",
              "الخبر",
              "بريدة",
              "تبوك",
              "الجبيل",
              "نجران",
              "جازان"
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value
                ),
              );
            }).toList(),
            onChanged: (String value) {
              setState(() {
                userCity = value;
              }
              
              );
            },
)),
                  SizedBox(height: 20.0),
                    
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: RaisedButton(
                      elevation: 0.0,
                      color: Colors.yellow[700],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
                      child: Text('سجل', style: TextStyle(color: Colors.white, fontSize: 16.0)),
                      onPressed: () {
                        _onRegister();
                      }
                    ),
                  ),

                  SizedBox(height: 10.0),
                    
                  Text.rich(
                    TextSpan(
                      text: "لديك حساب؟",
                      style: TextStyle(color:  Colors.grey[700], fontSize: 14.0),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'سجل الدخول',
                          style: TextStyle(color:  Colors.grey[700], decoration: TextDecoration.underline),
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
            ],
          ),
        )
      ),
    );
  }
}
