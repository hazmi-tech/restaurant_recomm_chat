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
  Future updateUserData(String fullName, String email, String password) async {
    return await userCollection.document(uid).setData({
      'fullName': fullName,
      'email': email,
      'password': password,
      'groups': [],
      'profilePic': ''
    });
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
  Future createGroup(String userName, String groupName,String city,String budget,String people) async {
    DocumentReference groupDocRef = await groupCollection.add({
      'groupName': groupName,
      'groupIcon': '',
      'isClosed':false,
      'createdOn': DateTime.now().millisecondsSinceEpoch,
      'city':city,
      'budget':double.parse(budget),
      'people':int.parse(people),
      'dist':'',
      'cuisine':'',
      'pickup':'',
      'event':'',
      'admin': uid,
      'members': [],
      //'messages': ,
      'groupId':'',
      'recentMessage': '',
      'recentMessageSender': ''
    }
        );
    
    groupDocRef .updateData({
      'groupId': groupDocRef.documentID,
    }
      
    );

    DocumentReference userDocRef = userCollection.document(uid);
    return await userDocRef.updateData({
      'groups': FieldValue.arrayUnion([groupDocRef.documentID + '_' + groupName])
    });

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

addGroupOptFields(groupId,String dist, String cuisine,String pickup,String event){
  if(dist!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'dist':dist});
  if(cuisine!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'cuisine':cuisine});
  if(pickup!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'pickup':pickup});
   if(event!=null)
  Firestore.instance.collection('groups').document(groupId).updateData({'event':event});
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