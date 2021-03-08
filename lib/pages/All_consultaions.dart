
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:group_chat_app/helper/helper_functions.dart';
import 'package:group_chat_app/pages/authenticate_page.dart';
import 'package:group_chat_app/pages/chat_page.dart';
import 'package:group_chat_app/pages/home_page.dart';
import 'package:group_chat_app/pages/myconsultaions.dart';
import 'package:group_chat_app/pages/order.dart';
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
int selectedRadio = 0;

setSelectedRadio(int val) {
  setState(() {
    selectedRadio = val;
  });
}
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



    String _chosenValue;


getMembers(DocumentSnapshot doc){

List<String> members = List.from(doc['members']);
return members;
}

 consultationSum(DocumentSnapshot doc){
 return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
          content:Container(

            height: 180,
            child: Column(
              
              children: [

          Text('تفاصيل الاستشارة',
          style: TextStyle(fontWeight:FontWeight.bold),
          ),
              const Divider(
               color: Colors.orange,
            height: 20,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
         

         Text.rich(
  TextSpan(
    
    style: TextStyle(
      
      fontSize: 17,
    ),
    children: [


      TextSpan(
        text: doc['people'].toString()+'   ',
      ),
            WidgetSpan(
        child: Icon(Icons.people),
      ),

      
      TextSpan(
        text: '     ' +doc['budget'].toString(),
      ),
            WidgetSpan(
        child: Icon(Icons.attach_money),
      ),
    ],

  ),
          textAlign:TextAlign.right,

),
        SizedBox(height:10,)  ,
       Text.rich(
  TextSpan(
    
    style: TextStyle(
      
      fontSize: 17,
    ),
    children: [
           WidgetSpan(
        child: Icon(Icons.location_pin,
         textDirection: TextDirection.rtl),
      ),

      TextSpan(
        text: doc['cuisine'].toString()==''?'غير محدد'+'   ':doc['cuisine']+'   ',
      ),
 

                  WidgetSpan(
        child: Icon(Icons.restaurant_rounded,
        textDirection: TextDirection.rtl,),
      ),
      TextSpan(
        text: doc['dist'].toString()==''?'غير محدد':doc['dist'],
      ),

      
  
    ],

  ),
          textAlign:TextAlign.right,
          textDirection: TextDirection.rtl,

),
 SizedBox(height:15,)  ,
   Text.rich(
  TextSpan(
    
    style: TextStyle(
      
      fontSize: 17,
    ),
    children: [


        TextSpan(
        text: doc['pickup'].toString()==''?"طريقة الاستلام: غير محددة":"طريقة الاستلام:"+doc['pickup'],
      ),

      
  
    ],

  ),
          textAlign:TextAlign.center,
          textDirection: TextDirection.rtl,

),

 SizedBox(height:15,)  ,
   Text.rich(
  TextSpan(
    
    style: TextStyle(
      
      fontSize: 17,
    ),
    children: [


        TextSpan(
        text: doc['event'].toString()==''?"المناسبة: غير محددة":"المناسبة :"+doc['event'],
      ),

      
  
    ],

  ),
          textAlign:TextAlign.center,
          textDirection: TextDirection.rtl,

),

            ],),
          ));
          
      }
 );
}


getExpenseItems(AsyncSnapshot<QuerySnapshot> snapshot) {

  List list = (snapshot.data.documents
        .map((doc) =>GestureDetector(
          onTap: (){

            consultationSum(doc);

          },
      child:  Container(
        child:Column(children: <Widget>[
          if (doc['admin']!=this._user.uid )
          if ( !(getMembers(doc)).contains(this._user.uid) )
          Container(padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
       child:  ListTile(
           contentPadding:EdgeInsets.only(top:20,left:5) ,
           leading:  RaisedButton(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(18.0),
  side: BorderSide(color: Colors.amber)
),
            onPressed: ()  {
              DatabaseService(uid: _user.uid).updateGroupMembers([this._user.uid],doc['groupId']);
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: doc['groupId'], userName:_userName, groupName: doc['groupName'],)));
            },
            child:  Text('شارك', style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600]
            )),
          ),
          
          title:  Text(doc['groupName'],
          textAlign: TextAlign.end
          , style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text('اضغط للحصول على التفاصيل',
          textAlign: TextAlign.end,
           style: TextStyle(fontSize: 13.0)),
          trailing:CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.amber[900],
            child: Text(doc['groupName'].substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
        )
        )
])
        )
        
        )
        )).toList();   

  return list;
          
  }

  Widget groupsList() {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection("groups").where('city', isEqualTo: _chosenValue ).where('isClosed', isEqualTo: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          
          if (!snapshot.hasData) return Center(
            child: CircularProgressIndicator( valueColor: new AlwaysStoppedAnimation<Color>(Colors.amber),), );
          return  new ListView(children: getExpenseItems(snapshot));
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
 await HelperFunctions.getUserEmailSharedPreference().then((value) {
      setState(() {
        _email = value;
      });


    });
 DatabaseService(uid: _user.uid).getUserData(_email).then((snapshot) {
      // print(snapshots);
      setState(() {
        _city= snapshot.documents[0].data['city'];
        _chosenValue =_city;
        _userName = snapshot.documents[0].data['fullName'];
        _email=snapshot.documents[0].data['email'];
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
          , preferredSize: Size.fromHeight(kToolbarHeight + 110)),
      body:body() ,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
 Navigator.push(context, MaterialPageRoute(builder: (context) => Order(uid:_user.uid,city:_city)));
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
                  Row( children: <Widget> [
      
                   Padding(
                     padding: EdgeInsets.only(left:20),
                    child:DropdownButton<String>(
                  icon:Icon(Icons.location_pin,
                  size:30 ,
                  color: Colors.white), 
            value: _chosenValue,
            //elevation: 5,
            style: TextStyle(color: Colors.black),

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
                child: Text(value),
              );
            }).toList(),
            hint:Text(this._city),
            onChanged: (String value) {
              setState(() {
                print(value);
                _chosenValue = value;
              });
            },
          )),
                  Padding(
                  padding: EdgeInsets.only(left:70 ),
                  child:Text(
                    'أحدث الاستشارات ',
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.white,
                    

                     fontSize: 25),
    
                  ))]),
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