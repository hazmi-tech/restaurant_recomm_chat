
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/chat_page.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/pages/profile_page.dart';
import 'package:group_chat_app/pages/search_page.dart';
import 'package:group_chat_app/services/auth_service.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/group_tile.dart';

class AllCons extends StatefulWidget {
  @override
  _AllConsState createState() => _AllConsState();
}

class _AllConsState extends State<AllCons>  {
TabController tabController;
final selectedColor = Colors.red;
int currentTab;
int _selectedIndex = 2;

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
  bool _isJoined = false;
  String _groupName;
  String _userName = '';
  String _email = '';
  String _city = '';
  Stream _groups;



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

getMembers(DocumentSnapshot doc){

List<String> members = List.from(doc['members']);
return members;
}
getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {

    return snapshot.data.documents
        .map((doc) =>GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: doc['groupId'], userName:_userName, groupName: doc['groupName'],)));
      },
      child:  Container(
        child:Column(children: <Widget>[
            if (doc['admin']!=this._user.uid )
            if ( !(getMembers(doc)).contains(this._user.uid+'_'+this._userName) )
          Container(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0)
         ,child:  ListTile(
           leading: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.grey[200],
          ),
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Text('جاوب', style: TextStyle(color: Colors.grey[600])),
          
        ),
          title:  Text(doc['groupName'],
          textAlign: TextAlign.end
          , style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("اضغط للحصول على التفاصيل ",
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
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("groups").where('city', isEqualTo: _city).where('isClosed', isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),), );
          return new ListView(children: getExpenseItems(snapshot));
         }
    );
  }


  // functions

    _joinValueInGroup(String userName, String groupId, String groupName, String admin) async {
    bool value = await DatabaseService(uid: _user.uid).isUserJoined(groupId, groupName, userName);
    setState(() {
      _isJoined = value;
    });
  }
  
  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser();
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
 await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });


    });
    await  DatabaseService(uid: _user.uid).getUserData(_email).then((snapshot) {
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

    break;
        case 3:
        Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));});

      break;
   break;
  }
  
    return Scaffold(
      appBar: PreferredSize(
          child:header()         
          , preferredSize: Size.fromHeight(kToolbarHeight + 100)),
      body:body() ,
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
      
  bottomNavigationBar:navigationBar()
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
                  padding: EdgeInsets.only(left:120 ),
                  child:Text(
                    'أحدث الاستشارات ',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white,
                    
                     
                     fontSize: 25),
    
                  )),
                  Padding(
                  padding: EdgeInsets.only(left:120 ),
                  child:Text(
                    'طلبات الاستشارة المطروحة حديثاً ',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white),
    
                  )),
                ],
              ),
 ));
}

Widget body(){

  return  Row(
          children: <Widget>[
           Expanded(child:  groupsList())]);
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