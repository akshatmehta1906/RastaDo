import 'package:flutter/material.dart';
import 'package:ambulance/models/amb.dart';

class UserTile extends StatelessWidget {

  final Amb user;
  UserTile({this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
            child: ListTile(
               leading: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.brown ,
              ),

              title: Text(user.name),


            ),
      ),
    );
  }
}
