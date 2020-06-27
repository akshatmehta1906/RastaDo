
import 'package:ambulance/services/auth.dart';
import 'package:ambulance/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:ambulance/shared/constants.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

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
                          'Welcome Back',
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
                    padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 20.0),

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

                        SizedBox(height: 50.0),

                        Container(
                          height: 40.0,
                          child: Material(
                            borderRadius: BorderRadius.circular(2.0),
                            shadowColor: Colors.blueAccent,
                            elevation: 7.0,
                            child: RaisedButton(
                              color: Colors.blue,
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() => loading = true);
                                  dynamic result = await _auth.signInWithEmailandPassword(
                                      email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = 'Invalid Credentials';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              child: Center(
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
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
                                child: Text('Create Account',
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

