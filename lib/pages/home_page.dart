import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/All_consultaions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/chat_page.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/pages/order.dart';
import 'package:group_chat_app/pages/profile_page.dart';
import 'package:group_chat_app/pages/search_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

int _selectedIndex = 3;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final AuthService _auth = AuthService();
  FirebaseUser _user;
  String _groupName;
  String _userName = '';
  String _email = '';
  Stream _groups;
    String _city = '';



  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }


  // widgets
  




  // functions
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



  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    setState(() => context = context);
     switch(_selectedIndex) {
    case 0:
Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage()));});

      break;

    case 1:
    Future.delayed(Duration.zero, () {
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>MyCons(),));});
      break;

    case 2:
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AllCons()));});

    break;

        case 3:
   break;
  }
  
    return Scaffold(
      appBar: PreferredSize(
          child: ClipPath(
            clipper: CustomAppBar(),
            child: Container(
              color: new Color(0xFFFF8046),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'الرئيسية  ',
                    style: TextStyle(color: Colors.white,
                     
                     fontSize: 25),
                  ),
                  Text(
                    'شبكة اجتماعية لهواة الطعام',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          preferredSize: Size.fromHeight(kToolbarHeight + 100)),
      body:SingleChildScrollView(
child:body()) ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
 Navigator.push(context, MaterialPageRoute(builder: (context) => Order(uid:_user.uid,city:_city)));
 }   ,
        child: Icon(Icons.add, color: Colors.amber[800], size: 30.0),
        backgroundColor: Colors.white,
        splashColor: Colors.grey,
        elevation: 0.0,
      ),
       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      
  bottomNavigationBar:navigationBar(),
    );
  }



Widget body(){

  return SingleChildScrollView(
child:Column(
// to apply margin in the main axis of the wrap
  
         children: <Widget>[
           
          Row( 
            children:<Widget>[ 
              Padding(padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10,bottom: 30),),
              SizedBox(width:20),
              ButtonTheme(child:adBtn()),
              SizedBox(width: 40),
              ButtonTheme(child:reqConBtn()),
         ]),
         SizedBox(height:20 ),
             Row( 
            
            children:<Widget>[ 
              Padding(padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10,bottom: 30),),
                SizedBox(width: 20),
              ButtonTheme(child:consBtn()),
              SizedBox(width: 40),
              ButtonTheme( child:newconsBtn()),
         ])
         ],

  ));
}


Widget reqConBtn(){
  return ButtonTheme(
         height: 120,
  minWidth: 120,
         child:  RaisedButton(
             color:Colors.white,
             shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Icon(Icons.add_comment,
                        color:Colors.amber ,
                        size: 30,),
                         Padding(
                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10),
                            child: new Text(
                              "استشير ",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ))
                        ]),
             onPressed: (){

Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Order()));});
 },
             ));
}

Widget consBtn(){
  return ButtonTheme(
         height: 120,
  minWidth: 100,
         child:  RaisedButton(
             color:Colors.white,
             shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Image.asset(
                          'assets/images/cons.png',
                          height: 40.0,
                          width: 40.0,
                        ),
                         Padding(
                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10),
                            child: new Text(
                              "استشاراتي ",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ))
                        ]),
             onPressed: (){
Future.delayed(Duration.zero, () {
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>MyCons(),));});

             },
             ));
}


Widget newconsBtn(){
  return ButtonTheme(
         height: 120,
  minWidth: 100,
         child:  RaisedButton(
             color:Colors.white,
             shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Image.asset(
                          'assets/images/chat.png',
                          height: 40.0,
                          width: 40.0,
                        ),
              
                         Padding(
                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10),
                            child: new Text(
                              "طلبات \nالاستشارة",
                              textAlign:TextAlign.center,
                              style: TextStyle(

                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ))
                        ]),
             onPressed: (){
               
Future.delayed(Duration.zero, () {
Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AllCons(),));});



             },
             ));
}


Widget adBtn(){
  return ButtonTheme(
         height: 120,
  minWidth: 120,
         child:  RaisedButton(
             color:Colors.white,
             shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(20)
  ),
  child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new Image.asset(
                          'assets/images/adbtn.png',
                          height: 40.0,
                          width: 40.0,
                        ),
                         Padding(
                            padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10),
                            child: new Text(
                              "العروض \n (قريباً)",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ))
                        ]),
             onPressed: (){
               
                   showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content: Text('قريباً' , textAlign: TextAlign.center,));
      },
    );
             },
             ));
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