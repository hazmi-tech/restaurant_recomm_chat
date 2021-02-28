
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/pages/All_consultaions.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';

class ProfilePage extends StatefulWidget {

  final String userName;
  final String email;
  final String city;

  ProfilePage({this.userName, this.email,this.city});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _auth = AuthService();

   int _selectedIndex=0;



  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String _groupName;
  String _city='';



  Stream _groups;


 FirebaseUser _user;

  String _destructureId(String res) {
    // print(res.substring(0, res.indexOf('_')));
    return res.substring(0, res.indexOf('_'));
  }

  String _destructureName(String res) {
    // print(res.substring(res.indexOf('_') + 1));
    return res.substring(res.indexOf('_') + 1);
  }

  void _popupDialog(BuildContext context) {
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget createButton = FlatButton(
      child: Text("Create"),
      onPressed:  () async {
        if(_groupName != null) {
          await HelperFunctions.getUserNameSharedPreference().then((val) {
            DatabaseService(uid: _user.uid).createGroup(val, _groupName);
          });
          Navigator.of(context).pop();
        }
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text("Create a group"),
      content: TextField(
        onChanged: (val) {
          _groupName = val;
        },
        style: TextStyle(
          fontSize: 15.0,
          height: 2.0,
          color: Colors.black             
        )
      ),
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
          preferredSize: Size.fromHeight(kToolbarHeight +240)),

          body: body(),
 
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _popupDialog(context);
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
String _userName = widget.userName;

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
                    
                     
                     fontSize: 35),
    
                  )
                  
                  ),
              Icon(Icons.account_circle, size: 150.0, color: Colors.white),
          
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
    String _userName = widget.userName;

  String _email =widget.email;
  String _city=widget.city;

  
  return SingleChildScrollView(
    reverse: true,
child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(padding:EdgeInsets.only(left: 60) 
              ,child: Column(children: [ Row(

                children: <Widget>[
Container(
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    height: 60,
                    width: 200,
                    child: TextField(
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
                children: <Widget>[
                    Container(
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    height: 60,
                    width: 200,
                    child: TextField(
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
                children: <Widget>[
                    Container(
                    padding: EdgeInsets.fromLTRB(10,10,10,10),
                    height: 60,
                    width: 200,
                    child: TextField(
                    textAlignVertical:TextAlignVertical.center,
                    textAlign:TextAlign.center,
                  decoration: InputDecoration(
  hintText: _city,
  
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5.0),
    borderSide: BorderSide(
      color: Colors.amber,
      style: BorderStyle.solid,
    ),
  ),
)),),
                  Text('المدينة', style: TextStyle(fontSize: 17.0)),
                
                ],
              )
              
              ,],)
              ),
             
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