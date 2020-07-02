import "package:flutter/material.dart";
import 'package:marathon/services/auth.dart';
// import 'package:marathon/shared/constants.dart';
import 'package:marathon/shared/loading.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/sign_in.dart';


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
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.brown[100],
            appBar: AppBar(
              backgroundColor: Colors.brown[400],
              elevation: 0.0,
              title: Text('Sign In'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Register"))
              ],
            ),
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print("register");
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return new Register();
                          }));
                        }
                      }
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
	                    child: Text('Not a member? Sign up!'),
	                    onPressed: () {
	                      print("register");
	                      Navigator.push(context,
	                          MaterialPageRoute(builder: (context) {
	                        return new SignIn();
	                      }));
	                    },
	                  ),
                  ],
                ),
              ),
            ),
          );
  }
}
