import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ambulance/shared/constants.dart';
import 'package:ambulance/services/database.dart';
import 'package:provider/provider.dart';
import 'package:ambulance/shared/loading.dart';
import 'package:ambulance/models/user.dart';




class GeolocationExampleState extends State {

  final _formKey = GlobalKey<FormState>();
  Geolocator _geolocator;
  Position _position;
  double _lat;
  double _long;


  void checkPermission() {
    _geolocator.checkGeolocationPermissionStatus().then((status) { print('status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationAlways).then((status) { print('always status: $status'); });
    _geolocator.checkGeolocationPermissionStatus(locationPermission: GeolocationPermission.locationWhenInUse)..then((status) { print('whenInUse status: $status'); });
  }

  @override
  void initState() {
    super.initState();

    _geolocator = Geolocator();
    LocationOptions locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 1);

    checkPermission();
    //    updateLocation();

    StreamSubscription positionStream = _geolocator.getPositionStream(locationOptions).listen(
            (Position position) {
          _position = position;
        });
  }

  void updateLocation() async {
    try {
      Position newPosition = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
          .timeout(new Duration(seconds: 5));

      setState(() {
        _position = newPosition;
      });
    } catch (e) {
      print('Error: ${e.toString()}');
    }

    _lat=_position.latitude.toDouble();
    _long=_position.longitude.toDouble();


  }



  void backend() async{

    final user= Provider.of<User>(context);

    StreamBuilder<UserData> (
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot)
        {
          if(snapshot.hasData)
          {

            UserData userData=snapshot.data;
            return Form
              (
                key: _formKey,
                onChanged:() async {
                  await DatabaseService(uid: user.uid).updateUserData(
                    '  ' ?? userData.name,
                    _lat ?? userData.latitude,
                    _long ?? userData.longitude,
                  );
                }
          );
          }
          else
          {
          return Loading();
          }

        }
    );



  }





  @override
  Widget build(BuildContext context) {



    return Scaffold(

      body: Center(
          child: Text(
              'Latitude: ${_position != null ? _position.latitude.toString() : '0'},'
                  ' Longitude: ${_position != null ? _position.longitude.toString() : '0'}'
          )
      ),
    );
  }
}

class GeolocationExample extends StatefulWidget {
  @override
  GeolocationExampleState createState() => new GeolocationExampleState();
}

