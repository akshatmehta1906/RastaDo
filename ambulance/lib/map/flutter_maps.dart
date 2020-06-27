import 'package:ambulance/alarm.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'dart:async';
import 'package:ambulance/models/amb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ambulance/services/auth.dart';
import 'package:ambulance/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ambulance/map/flutter_maps.dart';
import 'package:ambulance/models/user.dart';


var db= Firestore.instance.collection('ID');
var ambDB = Firestore.instance.collection('ID').document("V4BFp3NYtXhP6WO4DEdOckmD6fH3");
var carDB = Firestore.instance.collection('ID').document("6WJEVTcYWWPn6wY4SwsfaW7UGcv2");


class flutterMap extends StatefulWidget {
  @override
  _flutterMapState createState() => _flutterMapState();
}

class _flutterMapState extends State<flutterMap> {



  MapController controller = MapController();
  MapOptions options = MapOptions(
      center: LatLng(19.2334, 72.9133), minZoom: 15.0);
  Timer _timer;
  double _lat;
  double alat;
  double along;
  double _long;
  final _formKey = GlobalKey<FormState>();
  Geolocator _geolocator;
  Position _position;

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
          "6WJEVTcYWWPn6wY4SwsfaW7UGcv2").updateData({
        'longitude': _position.longitude.toDouble(),
        'latitude': _position.latitude.toDouble(),
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }

    dynamic documents = await ambDB.get();
    alat = documents.data['latitude'];
    along = documents.data['longitude'];


    _lat = _position.latitude.toDouble();
    _long = _position.longitude.toDouble();


    final user = Provider.of<User>(context);
    DatabaseService(uid: user.uid).userData;
    key:
    _formKey;


//    StreamBuilder<UserData>(
//        stream: DatabaseService(uid: user.uid).userData,
//        builder: (context, snapshot) {
//          UserData userData = snapshot.data;
//          DatabaseService(uid: user.uid).updateUserData(' ' ?? userData.name,
//              _lat ?? userData.latitude, _long ?? userData.longitude,
//              0 ?? userData.speed, 0 ?? userData.distance);
//        });
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

  buildMap(){
    controller.move(LatLng(alat, along), 5.0);
    return;
  }

    @override
    void initState() {

      _geolocator = Geolocator();
      LocationOptions locationOptions =
      LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);



      checkPermission();
      updateLocation();



      _timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
        updateLocation();
        buildMap();


      }
      );



      super.initState();
    }

    @override
    void dispose() {
      // TODO: implement dispose
      _timer.cancel();
      super.dispose();
    }


    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Maps'),
          centerTitle: true,
          backgroundColor: Colors.grey[800],



        ),
        body: FlutterMap(
          mapController: controller,
          options: options,
          layers: [
            TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c']
            ),
            MarkerLayerOptions(markers: [
              Marker(
                  point: LatLng(_lat, _long),
                  builder: (context) =>
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on, color: Colors.red,),
                          onPressed: null,
                          iconSize: 45.0,),
                      )
              ),
              Marker(
                  point: LatLng(alat, along),
                  builder: (context) =>
                      Container(
                        child: IconButton(
                          icon: Icon(Icons.location_on, color: Colors.blue,),
                          onPressed: null,
                          iconSize: 45.0,),
                      )
              )
            ],),
          ],
        ),
      );
    }
  }
