import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/my_cons_hist.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/shared/loading.dart';
import 'package:group_chat_app/widgets/message_tile.dart';

class ChatPage extends StatefulWidget {

  final String groupId;
  final String userName;
  final String groupName;

  ChatPage({
    this.groupId,
    this.userName,
    this.groupName
  });

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  String _userId;

 String _admin;

 String _adminName;

  bool _isClosed;

 
  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("الغاء"),
      onPressed:  () {
        DatabaseService().closeGroup(widget.groupId);
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) =>MyConshist(),));});

    Widget continueButton = FlatButton(
      child: Text("تراجع"),
      onPressed:  () {Navigator.pop(context);},
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("الغاء الاستشارة"),
      content: Text("هل أنت متأكد من رغبتك بإلغاء الاستشارة؟"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  Expanded(child:ListView.builder(
          padding:  const EdgeInsets.only(top:10,bottom: 100.0),
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.documents[index].data["message"],
              sender: snapshot.data.documents[index].data["sender"],
              sentByMe: widget.userName==  snapshot.data.documents[index].data["sender"],
              admin: _adminName,
            );
          }
        ))
        :
        Container();
      },
    );
  }


  _sendMessage() {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageEditingController.text,
        "sender": widget.userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    DatabaseService().getChats(widget.groupId).then((val){

      // print(val);
      setState(() {
        _chats = val;
      });
    });

      DatabaseService().searchByName(widget.groupName).then((snapshot) async {
      // print(val);
      setState(() {
        _adminName= snapshot.documents[0].data['adminName'];
        _isClosed=snapshot.documents[0].data['isClosed'];
      });

    });
  }


  @override
  Widget build(BuildContext context) {

    if(_isClosed==null )
    return Loading();
    else
    return Scaffold(

      
      appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black),
        title:SingleChildScrollView(
  scrollDirection: Axis.horizontal,
       child: Row(children: [

        Text("استشارة:"+_adminName, style: TextStyle(color: Colors.black,fontSize: 15)),
        

            Column(
              children: [
                Padding(
    padding: const EdgeInsets.all(28.0),
    child:widget.userName==_adminName?  RaisedButton(
            color: Colors.grey[200],
            shape: RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(18.0),
  side: BorderSide(color: Colors.amber)),
    child: Text('الغاء '),
    onPressed: () {
    showAlertDialog(context);
    },
    ): SizedBox(width: 0,)
    ),
              ],
            )
        ],
        ))
   ,backgroundColor: Colors.white,
        elevation: 0.4,
    ),
      body: Container(
        child: Stack(
          children: <Widget>[
            
            _chatMessages(),
            // Container(),
            Container(
              alignment: Alignment.bottomCenter,
              width: MediaQuery.of(context).size.width,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                color: Colors.grey[300],
                child: Row(
                  children: <Widget>[
                    
                    Expanded(
                      child: TextField(
                        enabled: _isClosed?false:true,
                        textAlign: TextAlign.right,
                        textDirection: TextDirection.rtl,
                        controller: messageEditingController,
                        style: TextStyle(
                          color: Colors.grey[500]
                        ),
                        decoration: InputDecoration(
                          hintText:_isClosed?"هذه الاستشارة مغلقة":"اكتب رسالتك هنا..",
                          hintStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                          border: InputBorder.none
                        ),
                      ),
                    ),

                    SizedBox(width: 12.0),

                    GestureDetector(
                      onTap: () {
                        _sendMessage();
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          color: new Color(0xFFFF8046),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: Center(child: Icon(Icons.send, color: Colors.white)),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
