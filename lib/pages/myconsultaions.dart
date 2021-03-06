import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/All_consultaions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/chat_page.dart';
import 'package:group_chat_app/pages/my_cons_hist.dart';
import 'package:group_chat_app/pages/order.dart';
import 'package:group_chat_app/pages/profile_page.dart';
import 'package:group_chat_app/pages/search_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';

import 'package:group_chat_app/pages/home_page.dart';

class MyCons extends StatefulWidget {
  @override
  _MyConsState createState() => _MyConsState();
}

class _MyConsState extends State<MyCons>  {
TabController tabController;
final selectedColor = Colors.red;
int currentTab;
int _selectedIndex = 1;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final AuthService _auth = AuthService();
  FirebaseUser _user;

  // initState
  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  currentTab = 0;
  }

  String _groupName;
  String _userName = '';
  String _email = '';
    String _city = '';

  Stream _groups;



  // widgets

getExpenseItems(bool joined, AsyncSnapshot<QuerySnapshot> snapshot) {
    return snapshot.data.documents
        .map((doc) =>GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: doc['groupId'], userName:_userName, groupName: doc['groupName'],)));
      },
      child:Container(
        child:Column(children: <Widget>[

          if (joined==false)
       Container(
         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0)
         ,child: ListTile(
          title:  Text(doc['groupName'],
          textAlign: TextAlign.end
          , style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("اضغط للحصول على التفاصيل",
          textAlign: TextAlign.end,
           style: TextStyle(fontSize: 13.0)),
          trailing:CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.amber[900],
            child: Text(doc['groupName'].substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
        ),)
        ,if (doc['admin']!=this._user.uid && joined==true)
       Container(
        
         padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0)
         ,child: ListTile(
          title:  Text(doc['groupName'],
          textAlign: TextAlign.end
          , style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("اضغط للحصول على التفاصيل",
          textAlign: TextAlign.end,
           style: TextStyle(fontSize: 13.0)),
          trailing:CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.amber[900],
            child: Text(doc['groupName'].substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
        ),)
        ])
        ))).toList();
  }

  Widget groupsList() {
    bool joined=false;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("groups").where('admin', isEqualTo: this._user.uid).where('isClosed', isEqualTo: false).orderBy('createdOn',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Center (child: Text("لم تقم بطرح أي استشارات"));
          return new ListView(children: getExpenseItems(joined,snapshot));
         }
    );
  }

  Widget joindgroupsList() {
    bool joined=true;
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("groups").where('members' ,arrayContains: this._user.uid).where('isClosed', isEqualTo: false).orderBy('createdOn',descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) return new Center (child: Text("لم تقم باستقبال أي استشارات"));
          return new ListView(children: getExpenseItems(joined,snapshot));
         }
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
    return Scaffold(
      appBar: PreferredSize(
          child: header(),
          preferredSize: Size.fromHeight(kToolbarHeight + 100)),
      body:body() ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
 Navigator.push(context, MaterialPageRoute(builder: (context) => Order(uid:_user.uid,city:_city,userName: _userName,)));

 }        ,
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                            
GestureDetector(
  onTap: () {
Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyConshist()));});
} ,
  child: Row( 
     children: <Widget> [
                    Padding(
                      padding: EdgeInsets.only(left:20),
                      child:Text("التاريخ",
                      style: TextStyle(color: Colors.white))),
     ]),),
 Column(
           
                children:[
                  
                  Padding( 
                    padding: EdgeInsets.only(left: 100),
                    child:Text(
                    'استشاراتي  ',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white,
                    

                     fontSize: 25),
    
                  ),
                   ),

                         Padding( 
                   padding: EdgeInsets.only(bottom:60,right:20),

                    child:Text(
                    'طلبات الاستشارة التي طرحتها أو استقبلتها ',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Colors.white,
                    ),
    
                  ),
                   )


                 ] )
                ],
              ),
 ));
}



Widget body(){
  
   // children:<Widget>[Expanded(child:  groupsList())]
  return DefaultTabController(
    child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // give the tab bar a height [can change hheight to preferred height]
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(
                  25.0,
                ),
                 border: Border.all(
      color: Colors.amber, //                   <--- border color
      width: 1.0,
    ),
              ),
              child: TabBar(
                controller: tabController,
                // give the indicator a decoration (color and border radius)
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                  color: Color(0xffffcc5c),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                tabs: [
                  // first tab [you can add an icon using the icon property]
                  Tab(
                    text: 'استقبلتها',
                  ),

                  // second tab [you can add an icon using the icon property]
                  Tab(
                    text: 'طرحتها',
                  ),
                ],
              ),
            ),
            // tab bar view here
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: [
                  // first tab bar view widget 
                   // first tab bar view widget 
                Row(
                    children: <Widget> [
                                  Container(
                    child: Expanded(child:  joindgroupsList(),),
            
                  ),])
                  // second tab bar view widget
                 ,     Row(
                    children: <Widget> [
                                  Container(
                    child: Expanded(child:  groupsList(),),
            
                  ),])
                ],
              ),
            ),
          ],
        )
), length: 2,
 initialIndex: 1,

);

    
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