import 'package:flutter/material.dart';
import 'package:group_chat_app/pages/chat_page.dart';

class GroupTile extends StatelessWidget {
  final String userName;
  final String groupId;
  final String groupName;

  GroupTile({this.userName, this.groupId, this.groupName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => ChatPage(groupId: groupId, userName: userName, groupName: groupName,)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
        child: ListTile(

          title:  Text(groupName,
          textAlign: TextAlign.end
          , style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("اضغط للحصول على التفاصيل",
          textAlign: TextAlign.end,
           style: TextStyle(fontSize: 13.0)),
          trailing:CircleAvatar(
            radius: 30.0,
            backgroundColor: Colors.amber[900],
            child: Text(groupName.substring(0, 1).toUpperCase(), textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
          ),
        ),
      ),
    );
  }
}