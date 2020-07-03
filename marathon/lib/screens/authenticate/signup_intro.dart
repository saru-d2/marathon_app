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
            //backgroundColor: Colors.blue,
            body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("media/images/Login-2.png"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
            child: Form(
              key: _formKey,

              // UI stuff start here
              child: Center(
                child: Column(
                  children: <Widget>[
                    // spacing
                    SizedBox(
                      height: ScreenConstants.percentHeight * 47,
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
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'or',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 60,
                      ),
                      color: Colors.yellow,
                      child: Text(
                        'Sign up with Email',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
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
                      child: Expanded(
                        child: Text(
                          'Already a member? Login',
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
            ),
          ));
  }
}
