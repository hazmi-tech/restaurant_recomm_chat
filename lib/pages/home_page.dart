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
  Widget noGroupWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              _popupDialog(context);
            },
            child: Icon(Icons.add_circle, color: Colors.grey[700], size: 75.0)
          ),
          SizedBox(height: 20.0),
          Text("ليس لديك أي طلبات استشارة"),
        ],
      )
    );
  }



  Widget groupsList() {
    return StreamBuilder(
      stream: _groups,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          if(snapshot.data['groups'] != null) {
            // print(snapshot.data['groups'].length);
            if(snapshot.data['groups'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  int reqIndex = snapshot.data['groups'].length - index - 1;
                  return GroupTile(userName: snapshot.data['fullName'], groupId: _destructureId(snapshot.data['groups'][reqIndex]), groupName: _destructureName(snapshot.data['groups'][reqIndex]));
                }
              );
            }
            else {
              return noGroupWidget();
            }
          }
          else {
            return noGroupWidget();
          }
        }
        else {
          return Center(
            child: CircularProgressIndicator()
          );
        }
      },
    );
  }


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
        } );
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


  // Building the HomePage widget
  @override
  Widget build(BuildContext context) {
    setState(() => context = context);
     switch(_selectedIndex) {
    case 0:
Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => ProfilePage(userName: _userName, email: _email,city:_city)));});

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
Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Order()));});
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
              SizedBox(width: 40),
              ButtonTheme(child:adBtn()),
              SizedBox(width: 40),
              ButtonTheme(child:reqConBtn()),
         ]),
         SizedBox(height:20 ),
             Row( 
            
            children:<Widget>[ 
              Padding(padding: EdgeInsets.only(left: 10.0,top: 10.0,right:10,bottom: 30),),
                SizedBox(width: 40),
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
                              "العروض ",
                              style: TextStyle(
                                  fontSize: 15.0, fontWeight: FontWeight.bold),
                            ))
                        ]),
             onPressed: (){},
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