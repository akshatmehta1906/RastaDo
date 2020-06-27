import 'package:ambulance/home/home.dart';
import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ambulance/services/auth.dart';
import 'package:ambulance/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ambulance/map/flutter_maps.dart';
import 'package:ambulance/shared/constants.dart';
import 'package:ambulance/models/user.dart';
import 'package:great_circle_distance2/great_circle_distance2.dart';


var db= Firestore.instance.collection('ID');
var ambDB = Firestore.instance.collection('ID').document("V4BFp3NYtXhP6WO4DEdOckmD6fH3");


void main() => runApp(Alarm());

class Alarm extends StatefulWidget {
  @override
  _AlarmState createState() => _AlarmState();
}

class _AlarmState extends State<Alarm> {
  AssetsAudioPlayer _assetsAudioPlayer;

  final AuthService _auth = AuthService();
  final FirebaseAuth authentication=FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();
  Geolocator _geolocator;
  Position _position;
  double _lat;
  double _long;
  String _name = "no name";
  Timer _timer;
  double alat;
  double along;
  double finaldist;
  int check = 1;
  double _speed;
//  String cuid;

//
//  getCurrentUser() async{
//    final FirebaseUser user=await authentication.currentUser();
//    final cuid= user.uid;
//    return cuid;
//
//  }



  double distanceInBetween(double alat, double along, double lat2,
      double long2) {
    var distanceInMeters = new GreatCircleDistance.fromDegrees(
        latitude1: alat, longitude1: along, latitude2: lat2, longitude2: long2);
    return distanceInMeters.haversineDistance();
  }


  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) {
      print('status: $status');
    });
    _geolocator
        .checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationAlways)
        .then((status) {
      print('always status: $status');
    });
    _geolocator.checkGeolocationPermissionStatus(
        locationPermission: GeolocationPermission.locationWhenInUse)
      ..then((status) {
        print('whenInUse status: $status');
      });
  }

  @override
  void initState() {
    super.initState();

//    cuid=getCurrentUser().toString();


    _assetsAudioPlayer = AssetsAudioPlayer();
    _assetsAudioPlayer.open(Audio("assets/song2.mp3"),);


    _geolocator = Geolocator();
    LocationOptions locationOptions =
    LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);


    checkPermission();
    updateLocation();

    _timer = Timer.periodic(Duration(seconds: 3), (Timer t) =>
        updateLocation()
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer.cancel();
    super.dispose();
  }

  void updateLocation() async {
    print("updating ...");
    try {
      Position newPosition = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));

      setState(() {
        _position = newPosition;
      });

//      cuid=getCurrentUser().toString();


      Firestore.instance.collection("ID").document(
          "6WJEVTcYWWPn6wY4SwsfaW7UGcv2".toString()).updateData({
        'longitude': _position.longitude.toDouble(),
        'latitude': _position.latitude.toDouble(),
        'distance': finaldist,
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }

    dynamic documents = await ambDB.get();
    alat = documents.data['latitude'];
    along = documents.data['longitude'];
    _speed = _position.speed.toDouble();


    _lat = _position.latitude.toDouble();
    _long = _position.longitude.toDouble();

    finaldist = distanceInBetween(alat, along, _lat, _long);

    if (finaldist > 1500) {
      check = 0;
    }

    final user = Provider.of<User>(context);
    DatabaseService(uid: user.uid).userData;
    key:
    _formKey;


    StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          DatabaseService(uid: user.uid).updateUserData(' ' ?? userData.name,
              _lat ?? userData.latitude, _long ?? userData.longitude,
              _speed ?? userData.speed, 0 ?? userData.distance);
        });
  }


  @override
  Widget build(BuildContext context) {
    if (check == 0) {
      return Home();
    }

    else {
      return Scaffold(
          backgroundColor: Colors.grey[900],
          appBar: AppBar(
            title: Text('ALERT!'),
            centerTitle: true,
            backgroundColor: Colors.grey[850],
            actions: <Widget>[
              FlatButton.icon(
                  onPressed: () async {
                    await _auth.signOut();
                  },
                  icon: Icon(Icons.person),
                  label: Text('Logout')),
            ],
          ),

          resizeToAvoidBottomPadding: false,
          body: SafeArea
            (
              child: Column
                (
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container
                      (
                      child: Stack
                        (
                        children: <Widget>[
                          Container
                            (
                            padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                            child: Text
                              (
                              'There is an',
                              style:
                              TextStyle
                                (
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                            child: Text(
                              'Ambulance near you',
                              style:
                              TextStyle(
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
                            child: Text(

                              'Distance: ${_position != null ? finaldist
                                  .toString() : '0'}'
                              ,
                              style:
                              TextStyle(
                                fontSize: 15.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    SizedBox(height: 10.0),

                    SizedBox(height: 50),
                    RaisedButton(
                      color: Colors.blue[400],
                      child: Text('Go To Maps',
                          style: TextStyle(color: Colors.white)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => flutterMap()),
                        );
                      },
                    ),


                  ]
              )
          )
      );
    }
  }

}