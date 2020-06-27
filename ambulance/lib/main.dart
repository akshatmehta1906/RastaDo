
import 'package:ambulance/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:ambulance/wrapper/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:ambulance/models/user.dart';



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home:Wrapper(),
      ),
    );
  }
}


