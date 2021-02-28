import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:group_chat_app/services/database_service.dart';
import 'package:group_chat_app/widgets/message_tile.dart';
import 'package:group_chat_app/pages/chat.dart';


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

class _ChatPageState extends State<ChatPage> with SingleTickerProviderStateMixin {
  
  Stream<QuerySnapshot> _chats;
  TextEditingController messageEditingController = new TextEditingController();

  Widget _chatMessages(){
    return StreamBuilder(
      stream: _chats,
      builder: (context, snapshot){
        return snapshot.hasData ?  ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MessageTile(
              message: snapshot.data.documents[index].data["message"],
              sender: snapshot.data.documents[index].data["sender"],
              sentByMe: widget.userName == snapshot.data.documents[index].data["sender"],
            );
          }
        )
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
    DatabaseService().getChats(widget.groupId).then((val) {
      // print(val);
      setState(() {
        _chats = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        elevation: 0.4,
        iconTheme: IconThemeData(color: Colors.black),
    backgroundColor: Colors.white,
    title: Row(
    children: <Widget>[
    Container(
    width: 40,
    height: 40,
    margin: EdgeInsets.fromLTRB(0, 5, 10, 0),
    child: CircleAvatar(
    backgroundImage: NetworkImage('https://i.pravatar.cc/110'),
    backgroundColor: Colors.grey[200],
    minRadius: 30,
    ),
    ),
    Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    Text(
    'محمد العيدروس',
    style: TextStyle(color: Colors.black),
    ),
    Text(
    'متصل الان',
    style: TextStyle(
    color: Colors.grey[400],
    fontSize: 12,
    ),
    )

    ],
    ),
            Column(
              children: [
                Padding(
    padding: const EdgeInsets.all(28.0),
    child: RaisedButton(
    child: Text('الغاء الاستشارة'),
    onPressed: () {
    showAlertDialog(context);
    },
    ),
    ),
              ],
            )
    ],
    ),
    ),
    body: Stack(
    children: <Widget>[
    Container(
    color: Colors.white,
    child: Column(
    children: <Widget>[
    Flexible(
    child: ListView.builder(
    itemCount: 1,
    shrinkWrap: true,
    itemBuilder: (BuildContext context, int index) {
    return Padding(
    padding: EdgeInsets.all(10),
    child: Column(
    children: <Widget>[
    //Text(
    //'11:12',
    //style:
    //TextStyle(color: Colors.grey, fontSize: 12),
    //),
    Bubble(
    message: 'مطعم مأكولات بحرية فاخر عدد الأشخاص: 10 نوع المناسبة: اجتماع عمل، الاستلام في المطعم',
    isMe: true,
    ),
    Bubble(
    message: 'أهلاً معك محمد العيدروس، مطعم توينا أكثر مطعم بحري مناسب لهذا النوع من المناسبات، هادئ وراقي',
    isMe: false,
    ),
    //Text(
    //'Feb 25, 2018',
    //style:
    //TextStyle(color: Colors.grey, fontSize: 12),
    //),
    Bubble(
    message: 'تسلم الله يعطيك العافية',
    isMe: true,
    ),
    Bubble(
    message: 'ولو في الخدمة، عليكم بالعافية',
    isMe: false,
    ),
    ],

    ),
    );
    },
    ),
    ),
    ],
    ),
    ),
      Positioned(
        bottom: 0,
        left: 0,
        width: MediaQuery.of(context).size.width,
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(
              color: Colors.grey[300],
              offset: Offset(-2, 0),
              blurRadius: 5,
            ),
          ]),
          child: Row(
            children: <Widget>[
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.camera,
                  color: Color(0xff3E8DF3),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.image,
                  color: Color(0xff3E8DF3),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: 'ارسال',
                    border: InputBorder.none,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.send,
                  color: Color(0xff3E8DF3),
                ),
              ),
            ],
          ),
        ),
      )
    ],
    ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("الغاء"),
      onPressed:  () {},
    );
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
}

class Bubble extends StatelessWidget {
  final bool isMe;
  final String message;

  Bubble({this.message, this.isMe});

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      padding: isMe ? EdgeInsets.only(left: 40) : EdgeInsets.only(right: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        1
                      ],
                      colors: [
                        Color(0xFFFDA085),
                        Color(0xFFFDA085),
                      ])
                      : LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      stops: [
                        0.1,
                        1
                      ],
                      colors: [
                        Color(0xFFEBF5FC),
                        Color(0xFFEBF5FC),
                      ]),
                  borderRadius: isMe
                      ? BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(0),
                    bottomLeft: Radius.circular(15),
                  )
                      : BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(0),
                  ),
                ),
                child: Column(
                  crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      message,
                      textAlign: isMe ? TextAlign.end : TextAlign.start,
                      style: TextStyle(
                        color: isMe ? Colors.white : Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
