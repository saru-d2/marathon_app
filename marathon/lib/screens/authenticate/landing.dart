import "package:flutter/material.dart";
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/loading.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/login.dart';
import 'package:marathon/shared/constants.dart';


class Landing extends StatefulWidget {
  final Function toggleView;
  Landing({this.toggleView});

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  //states
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ScreenConstants().init(context);
    return loading
        ? Loading()
        : Scaffold(
            body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("media/images/Landing_BackGrnd.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: ScreenConstants.percentHeight * 60,
                          ),
                          RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              padding: EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 120,
                              ),
                              color: Colors.yellow,
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  print("register");
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return new Register();
                                  }));
                                }
                              }),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            child: Text(
                              'Already a member? Log in',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              print("register");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return new Login();
                              }));
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                )));
  }
}
