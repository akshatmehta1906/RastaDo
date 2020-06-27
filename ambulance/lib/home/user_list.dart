import 'package:flutter/material.dart';
import 'package:ambulance/models/amb.dart';
import 'package:provider/provider.dart';
import 'package:ambulance/home/user_tile.dart';

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  @override
  Widget build(BuildContext context) {

    final users=Provider.of<List<Amb>>(context)?? [];

    return ListView.builder(
      itemCount: users.length,
      itemBuilder:(context, index){
        return UserTile(user: users[index]);

      } ,
    );
  }
}
