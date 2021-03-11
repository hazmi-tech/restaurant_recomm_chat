
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/pages/All_consultaions.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/pages/order.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';

class ProfilePage extends StatefulWidget {


  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

   int _selectedIndex=0;
   String _chosenValue;

  bool _editprofile;

  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _groupName;
  String _userName='';
  String _city='';
   String _email='';
  String _pass='';


  Stream _groups;



 FirebaseUser _user;




  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserGroups().then((snapshots) {
      // print(snapshots);
      setState(() {
        _groups = snapshots;
      });
    });
    await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });
    });
    DatabaseService(uid: _user.uid).getUserData(_email).then((snapshot) {
      // print(snapshots);
      setState(() {
        _city= snapshot.documents[0].data['city'];
        _userName = snapshot.documents[0].data['fullName'];
        _email=snapshot.documents[0].data['email'];        } );
    });
  }
  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }


AlertDialog passAlert(newEmail){
  return  AlertDialog(
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text(" قم بإدخال كلمة المرور "
      ,textAlign:TextAlign.right ,),
       content: Row(
                               mainAxisAlignment: MainAxisAlignment.center,

         children: <Widget> 
       [  

         Container(
           height: 60,
           width: 200,
           child:TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'أدخل كلمة المرور',
                      ),
                      autofocus: false,
                      obscureText: true,
                      onSubmitted:(pass) async {
          final  user = await FirebaseAuth.instance.currentUser();
          final result = await InternetAddress.lookup('google.com');
      
           try {
                    String userId  = (await FirebaseAuth.instance.currentUser()).uid;
             if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
               AuthResult authResult = await user.reauthenticateWithCredential(
  EmailAuthProvider.getCredential(email: user.email ,password:pass),);
                authResult.user.updateEmail(newEmail);
                DatabaseService(uid: userId ).updateUserEmail(newEmail);
                Text('تم التحديث ينجاح');
                  await _auth.signOut();
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
                }
                } catch (e) {
                  Text('كلمة المرور خاطئة');
                  print(e);}
          }

                      ,
                      ),)
                      
                    ]),
    );
}
  void _popupDialog(BuildContext context, String newUserName, String newEmail, String newCity) {
    Widget cancelButton = FlatButton(
      child: Text("الغاء"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("تحديث"),
      onPressed:  ()  async {
       String userId  = (await FirebaseAuth.instance.currentUser()).uid;
          if(newUserName!=null)
          await DatabaseService(uid: userId).updateUserName(newUserName);

          if(newCity!=null)
           await DatabaseService(uid: userId ).updateUserCity(newCity);

          if(newEmail!=null){
              return showDialog(
      context: context,
      builder: (BuildContext context) {
        return passAlert(newEmail);
      },
    );

        }
        

                 Navigator.of(context).pop(); 
      },
      
    );

    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
      title: Text("هل تريد تحديث بياناتك؟"
      ,textAlign:TextAlign.right ,),
      actions: [
        cancelButton,
        createButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    setState(() => context = context);

     switch(_selectedIndex) {
    case 0:

      break;

    case 1:
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyCons()));});

       break;

    case 2:
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AllCons()));});

    break;
  case 3:
        Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));});
   break;
  }

    return   Scaffold(
      appBar: PreferredSize(
          child: header(),
          preferredSize: Size.fromHeight(kToolbarHeight +190)),

          body: body(),
 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
 Navigator.push(context, MaterialPageRoute(builder: (context) => Order(uid:_user.uid,city:_city,userName: _userName)));

        },
        child: Icon(Icons.add, color: Colors.amber[800], size: 30.0),
        backgroundColor: Colors.white,
        splashColor: Colors.grey,
        elevation: 0.0,
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
  bottomNavigationBar:navigationBar(),
    );
  
  }
Widget header(){

 return  ClipPath(
            clipper: CustomAppBar(),
            child:          Container(
              color: new Color(0xFFFF8046),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
               
              
                children: <Widget>[

                  Padding(
                  padding: EdgeInsets.only(top: 0 ),
                  child:Text(
                    
                    'أهلاً ' + _userName ,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white,
                    
                     
                     fontSize: 30),
    
                  )
                  
                  ),
              Icon(Icons.account_circle, size: 130.0, color: Colors.white),
          
GestureDetector(
  onTap: () async {
                await _auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AuthenticatePage()), (Route<dynamic> route) => false);
              } ,
  child: Text("تسجيل الخروج",
   style: TextStyle(color: Colors.red[900 ])),
),
                ],
              ),
 ));
}

Widget body(){
 
  String _newUserName ;
  String _newEmail ;
  String _newCity;


  return SingleChildScrollView(
    reverse: true,
child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            Column(children: [ Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
Container(
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    height: 60,
                    width: 200,
                    
                    child: TextField(
                            onChanged:(text) {
                            _newUserName=text;
                            _editprofile=true;} ,
                    textAlignVertical:TextAlignVertical.center,
                    textAlign:TextAlign.center,
                  decoration: InputDecoration(
  hintText: _userName,
  
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ),
)),),                                    Text('الاسم', style: TextStyle(fontSize: 17.0)),
                ],
              ),
              Row(
                                      mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                    Container(
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    height: 60,
                    width: 200,
                    child: TextField(
                    onTap: () {


                    },
                    onChanged:(text) {
                      _newEmail=text;
                _editprofile=true;} ,
                    textAlignVertical:TextAlignVertical.center,
                    textAlign:TextAlign.center,
                  decoration: InputDecoration(
  hintText: _email,
  
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ),
)),),
                  Text('الإيميل', style: TextStyle(fontSize: 17.0)),
                
                ],
              ),
               Row(
                                  mainAxisAlignment: MainAxisAlignment.center,

                children: <Widget>[
                    Container(
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    height: 60,
                    width: 200,
                    child:DropdownButton<String>(
                      isExpanded: true,
            hint: Text(_city,
                      textAlign: TextAlign.start,),
            value: _chosenValue,
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
                _chosenValue = value;
              }
              
              );
                 _editprofile=true;
            },
))
                  ,Text('المدينة', style: TextStyle(fontSize: 17.0)),
                
                ],
              ),
            
             Row(
                      mainAxisAlignment: MainAxisAlignment.center,

              children:[
                RaisedButton(
            color: Colors.yellow[700],
            shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(18.0),
),
            onPressed :() {
               print(_editprofile);
            if(!_editprofile) 
            ;
            else
             _popupDialog(context,_newUserName,_newEmail,_chosenValue);},
            child:  Text('حدث معلوماتك', style: TextStyle(
              fontSize: 14,
              color: Colors.white
            )),
          )]),
              
              ],)
              
             
            ],
          )));
}

  BottomNavigationBar navigationBar(){

  return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          
          BottomNavigationBarItem(
            icon: Icon(Icons.person
            ),
            label: 'الملف الشخصي',
            
          ),
          BottomNavigationBarItem(
          icon: Icon(Icons.restaurant),
          label: 'استشاراتي',),

                      BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'طلبات الاستشارة',

            
          ),
                    BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          )
          ,
        ],
        currentIndex:_selectedIndex,
        selectedItemColor: Colors.amber[800],
        unselectedFontSize: 10,
        selectedFontSize:10 ,
        iconSize: 14,
        onTap: _onItemTapped,
      );
}
}




class CustomAppBar extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}

 void onTabTapped(int index) {
   
  }


class PlaceholderWidget extends StatelessWidget {
  final Color color;

  PlaceholderWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}