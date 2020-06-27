import 'package:ambulance/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ambulance/models/amb.dart';

class DatabaseService{

  final String uid;
  DatabaseService({this.uid});
    
//collection reference
  final CollectionReference userCollection = Firestore.instance.collection('ID');

  Future updateUserData(String name, double latitude, double longitude, double distance, double speed ) async
  {
    return await userCollection.document(uid).setData({
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'speed': speed,
      'distance': distance,
    });
  }
    //amb list from snapshot
  List<Amb> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Amb(
        name:doc.data['name']?? '',
        latitude:doc.data['longitude']?? 0,
        longitude:doc.data['latitude']?? 0,
        distance:doc.data['distance']?? 0,
        speed:doc.data['speed']?? 0,

      );
    }).toList();
  }

  //userData from snapshot

  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot.data['name'],
      latitude: snapshot.data['latitude'],
      longitude: snapshot.data['longitude'],
      distance: snapshot.data['distance'],
      speed: snapshot.data['speed'],

    );
  }

    //get stream
    Stream<List<Amb>> get users
  {
    return userCollection.snapshots().map(_userListFromSnapshot);
  }

  //get user doc stream
  Stream<UserData> get userData{
    return userCollection.document(uid).snapshots().map(_userDataFromSnapshot);
  }

  }

