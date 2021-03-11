import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({
    this.uid
  });

  // Collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference groupCollection = Firestore.instance.collection('groups');

  // update userdata
  Future updateUserData(String fullName, String email, String city) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'city':city,
      'groups': [],
      'profilePic': ''
    });
  }

  Future getUserDatabById(uid) async {
    return userCollection.document(uid).snapshots();
  }
    Future updateUserName( String fullName) async {
    return await userCollection.document(uid).updateData({
      'fullName': fullName,
    });
  }

      Future updateUserCity( String city) async {
    return await userCollection.document(uid).updateData({
      'city': city,
    });
  }
    Future updateUserEmail( String email) async {
    return await userCollection.document(uid).updateData({
      'email': email,    });
  }

  





  


  // create group
  Future createGroup(String userName, String groupName,String city,String budget,String people, String dist,String cuisine,String event, String pickup) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'isClosed':false,
      'createdOn': DateTime.now().millisecondsSinceEpoch,
      'city':city,
      'budget':double.parse(budget),
      'people':int.parse(people),
      'dist':dist,
      'adminName':userName, 
      'cuisine':cuisine,
      'pickup':pickup,
      'event':event,
      'admin': uid,
      'members': [],
      'messages': '',
      'groupId':'',
      'recentMessage': '',
      'recentMessageSender': ''
    }
        );
    
    groupDocRef .updateData({
      'groupId': groupDocRef.documentID,
    }
      
    );

  if(dist!=null)
  groupDocRef.updateData({'dist':dist});

  if(cuisine!=null)
  groupDocRef.updateData({'cuisine':cuisine});


  if(pickup!=null)
 groupDocRef.updateData({'pickup':pickup});


   if(event!=null)
 groupDocRef.updateData({'event':event});


    groupDocRef.collection('messages').document().setData(
        {
        "message":"تفاصيل الاستشارة : \n"
        "الوصف: "+ groupName+"\n"+
        " الميزانية: "+ budget+"  عدد الأشخاص:  "+people+"\n\n"+
        "تفاصيل إضافية : \n"+
        "طريقة الاستلام: "+pickup+"\n"+"الحي: "+dist+"\n"+
        " نوع المطعم: "+ cuisine+"  المناسبة:  "+event+"\n" , 
        
        "sender": userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      }

    );

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'groups': FieldValue.arrayUnion([groupDocRef.documentID + '_' + groupName])
    });

  }


  closeGroup(String groupId){
  Firestore.instance.collection('groups').document(groupId).updateData({'isClosed':true});

  }


  // toggling the user group join
  Future togglingGroupJoin(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    DocumentReference groupDocRef = groupCollection.document(groupId);

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    if(groups.contains(groupId + '_' + groupName)) {
      //print('hey');
      await userDocRef.updateData({
        'groups': FieldValue.arrayRemove([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayRemove([uid + '_' + userName])
      });
    }
    else {
      //print('nay');
      await userDocRef.updateData({
        'groups': FieldValue.arrayUnion([groupId + '_' + groupName])
      });

      await groupDocRef.updateData({
        'members': FieldValue.arrayUnion([uid + '_' + userName])
      });
    }
  }


updateGroupMembers(List<dynamic> member, groupId ){
  Firestore.instance.collection('groups').document(groupId).updateData({"members": FieldValue.arrayUnion(member)});
}

addGroupOptFields(groupId,String userName,String dist, String cuisine,String pickup,String event){
  if(dist!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'dist':dist});
  else
  dist="";

  if(cuisine!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'cuisine':cuisine});
   else
  cuisine="";

  if(pickup!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'pickup':pickup});
   else
 pickup="";

   if(event!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'event':event});
   else
  event="";


  Firestore.instance.collection('groups').document(groupId).collection('messages').document().setData(
        {
        "message":"تفاصيل إضافية : \n"+"طريقة الاستلام: "+dist+"\n"+
        " نوع المطعم: "+ cuisine+"  المناسبة:  "+event+"\n" , 
        "sender": userName,
        'time': DateTime.now().millisecondsSinceEpoch,
      }

    );
}

  // has user joined the group
  Future<bool> isUserJoined(String groupId, String groupName, String userName) async {

    DocumentReference userDocRef = userCollection.document(uid);
    DocumentSnapshot userDocSnapshot = await userDocRef.get();

    List<dynamic> groups = await userDocSnapshot.data['groups'];

    
    if(groups.contains(groupId + '_' + groupName)) {
      //print('he');
      return true;
    }
    else {
      //print('ne');
      return false;
    }
  }


  // get user data
  Future getUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where('email', isEqualTo: email).getDocuments();
    print(snapshot.documents[0].data);
    return snapshot;
  }



Future<String> getSpecie(String email) async {
    DocumentReference documentReference = userCollection.where('email', isEqualTo: email) as DocumentReference;
    String specie;
    await documentReference.get().then((snapshot) {
      specie = snapshot.data['specie'].toString();
    });
    return specie;
  }

  // get user groups
  getUserGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance.collection("users").document(uid).snapshots();
  }

    getUserAdminGroups(groupId) async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance.collection('groups').document(groupId).snapshots();
  }



  // get user groups
 getAllGroups() async {
    // return await Firestore.instance.collection("users").where('email', isEqualTo: email).snapshots();
    return Firestore.instance.collection("groups").snapshots();
  }

  // send message
  sendMessage(String groupId, chatMessageData) {
    Firestore.instance.collection('groups').document(groupId).collection('messages').add(chatMessageData);
    Firestore.instance.collection('groups').document(groupId).updateData({
      'recentMessage': chatMessageData['message'],
      'recentMessageSender': chatMessageData['sender'],
      'recentMessageTime': chatMessageData['time'].toString(),
    });
  }


  // get chats of a particular group
  getChats(String groupId) async {
    return Firestore.instance.collection('groups').document(groupId).collection('messages').orderBy('time').snapshots();
  }


  // search groups
  searchByName(String groupName) {
    return Firestore.instance.collection("groups").where('groupName', isEqualTo: groupName).getDocuments();
  }
}