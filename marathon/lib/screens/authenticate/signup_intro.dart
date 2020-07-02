import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/sign_in.dart';
import 'package:marathon/screens/authenticate/landing.dart';
import 'package:marathon/shared/constants.dart';
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/loading.dart';

class Signup_Intro extends StatefulWidget {
  final Function toggleView;
  Signup_Intro({this.toggleView});

  @override
  _Signup_IntroState createState() => _Signup_IntroState();
}

class _Signup_IntroState extends State<Signup_Intro> {

  //states
  String email = '';
  String password = '';
  String error = '';
  bool loading = false;

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    ScreenConstants().init(context);
    return loading
        ? Loading
        : Scaffold(
            backgroundColor: Colors.blue,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Form(
                key: _formKey,

                // UI stuff start here
                child: Column(
                  children: <Widget>[

                    // spacing
                    SizedBox(
                      height: 20,
                    ),

                    SignInButton(
                      Buttons.Google,
                      onPressed: () async {
                        print("google");
                        dynamic result = await _auth.signInWithGoogle();
                        if (result == null) print("sign in failed lol");
                      },
                    ),
                    SignInButton(
                      Buttons.Facebook,
                      onPressed: () {
                        print("facebook");
                      },
                    ),
                    Text('or'),

                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
                      ),
                      // button pressed
                      onPressed: () {
                        print("register");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return new Register();
                        }));
                        
                      },
                    ),


                    // go to  page
                    FlatButton(
                      child: Text('Already a member? Login!'),
                      onPressed: () {
                        print("register");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return new Register();
                        }));
                      },
                    )



                  ],
                ),
              ),
            ));
  }
}
