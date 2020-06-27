import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(


      child: Container(


      color: Colors.blueAccent[100],
      child: Center(
        child: SpinKitChasingDots(
          color: Colors.brown,
          size:50,
           ),
         ),
        ),
      ),
    );
  }
}
