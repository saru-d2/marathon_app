import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/sign_in.dart';
import 'package:marathon/screens/authenticate/landing.dart';
import 'package:marathon/screens/authenticate/login.dart';
import 'package:marathon/shared/constants.dart';
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/loading.dart';

class SignUpIntro extends StatefulWidget {
  final Function toggleView;
  SignUpIntro({this.toggleView});

  @override
  _SignUpIntroState createState() => _SignUpIntroState();
}

class _SignUpIntroState extends State<SignUpIntro> {

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
                        'Sign up with Email',
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
                      child: Text('Already a member? Login'),
                      onPressed: () {
                        print("register");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return new Login();
                        }));
                      },
                    )



                  ],
                ),
              ),
            ));
  }
}
