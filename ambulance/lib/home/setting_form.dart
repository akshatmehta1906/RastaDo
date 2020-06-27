import 'package:ambulance/models/user.dart';
import 'package:ambulance/services/database.dart';
import 'package:ambulance/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ambulance/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SettingsForm extends StatefulWidget {
  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  final List<String> drivingst = ['YES', 'N0'];

  //form values
  String _currentname;
  double _currentlatitude;
  double _currentlongitude;


  @override
  Widget build(BuildContext context) {

    final user= Provider.of<User>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userData,
      builder: (context, snapshot)
      {
        if(snapshot.hasData)
        {

            UserData userData=snapshot.data;
            return Form
              (
                key: _formKey,
                child: Column
                  (
                    children: <Widget>[
                      Text
                        (
                        'Update Your User Settings',
                        style: TextStyle(fontSize: 18),
                        ),
                      SizedBox(height: 20),
                      TextFormField(
                        initialValue: userData.name,
                        decoration: textInputDecorations,
                        validator: (val) => val.isEmpty ? 'Please enter a name' : null,
                        onChanged: (val) => setState(() => _currentname = val),
                     ),

                      SizedBox(height: 20),
                      TextFormField(
                        //initialValue: userData.latitude,
                        decoration: textInputDecorations,
                        validator: (val) => val.isEmpty ? 'Please car details' : null,
                        //onChanged: (val) => setState(() => _currentlatitude = val),
                     ),

                      SizedBox(height: 20),

                    //dropdown
                      DropdownButtonFormField(
                        decoration: textInputDecorations,
                       value: _currentlongitude, //?? drivingstatus,

                        items: drivingst.map((drivingstatus){
                          return DropdownMenuItem(
                          value: drivingstatus,
                          child: Text('Do you drive?-$drivingstatus'),
                        );
                      }).toList(),
                      onChanged: (val)=>setState(()=>_currentlongitude=val),
                    ),

                    RaisedButton(
                      color: Colors.pink,
                      child: Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                        ),
                      onPressed: () async{
                        if(_formKey.currentState.validate())
                          {
                            await DatabaseService(uid: user.uid).updateUserData(
                              _currentname?? userData.name,
                              _currentlatitude?? userData.latitude,
                              _currentlongitude?? userData.longitude,
                            );
                            Navigator.pop(context);
                          }
                      },
                    ),
                  ],
                ),
          );
        }
        else
          {
            return Loading();
          }

      }
    );
  }
}
