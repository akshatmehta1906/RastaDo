import 'package:ambulance/models/amb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ambulance/services/auth.dart';
import 'package:ambulance/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ambulance/map/flutter_maps.dart';
import 'package:ambulance/shared/constants.dart';
import 'package:ambulance/shared/loading.dart';
import 'package:ambulance/models/user.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  Geolocator _geolocator;
  Position _position;
  double _lat;
  double _long;
  String _name = "no name";
  Timer _timer;

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



      Firestore.instance.collection("ID").document(
          "V4BFp3NYtXhP6WO4DEdOckmD6fH3").updateData({
        'longitude': _position.longitude.toDouble(),
        'latitude': _position.latitude.toDouble(),
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }

    _lat = _position.latitude.toDouble();
    _long = _position.longitude.toDouble();

    final user = Provider.of<User>(context);
    DatabaseService(uid: user.uid).userData;
    key:_formKey;


    StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          DatabaseService(uid: user.uid).updateUserData(' ' ?? userData.name,
              _lat ?? userData.latitude, _long ?? userData.longitude);
        });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[900],
        appBar: AppBar(
          title: Text('RastaDo'),
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
                            'Hello.',
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
                            'Your journey has started',
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


                ]
            )
        )
    );
  }


}