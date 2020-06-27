import 'package:ambulance/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ambulance/services/auth.dart';
import 'package:ambulance/shared/constants.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({this.toggleView});


  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth=AuthService();
  final _formKey=GlobalKey<FormState>();
  bool loading=false;

  //text field state
  String email='';
  String password='';
  String error='';

  @override
  Widget build(BuildContext context) {
    return loading? Loading(): Scaffold(

      backgroundColor: Colors.grey[900],
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
    'New Here?',
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
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
              children: <Widget>[
                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecorations.copyWith(hintText: 'Email'),
                    validator: (val)=> val.isEmpty ? 'Enter an Email': null ,
                    onChanged: (val)
                    {
                      setState(()=>email=val);
                    }
                ),

                SizedBox(height: 20),
                TextFormField(
                  decoration: textInputDecorations.copyWith(hintText: 'Password'),
                  validator: (val)=> val.length<6 ? 'Enter a password of more than 6 characters': null ,
                  obscureText: true,
                  onChanged: (val)
                  {
                    setState(()=>password=val);
                  },
                ),







                SizedBox(height: 10.0),

                SizedBox(height: 50),
                RaisedButton(
                    color: Colors.blue[400],
                    child: Text('Register',
                        style: TextStyle(color: Colors.white)),
                    onPressed: () async{
                      setState(() => loading=true );
                      if(_formKey.currentState.validate())
                      {
                        dynamic result=await _auth.registerWithEmailandPassword(email, password);
                        if(result==null)
                        {
                          setState((){
                            error='Please supply a valid Email';
                            loading=false;
                          });

                        }
                      }

                    }
                ),




                SizedBox(height:20),
                Text(error, style: TextStyle(color: Colors.red, fontSize: 14)),



                SizedBox(height: 20.0),

                Container(
                  height: 40.0,
                  color: Colors.transparent,
                  child: Container(
                    child: InkWell(
                      onTap: () {
                        widget.toggleView();
                      },
                      child: Center(
                        child: Text('Login',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],

                            )
                        ),
                      ),


                    ),
                  ),
                ),
              ],
          )
        ),



      ),
            ]
        ),
      )
    );


  }
}




