import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/sign_in.dart';
import 'package:marathon/screens/authenticate/landing.dart';
import 'package:marathon/screens/Forgot_Password.dart';
import 'package:marathon/screens/authenticate/signup_intro.dart';
import 'package:marathon/shared/constants.dart';
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/loading.dart';

class Login extends StatefulWidget {
  final Function toggleView;
  Login({this.toggleView});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
            // backgroundColor: Colors.blue,
            body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("media/images/Login.png"),
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
                      height: ScreenConstants.percentHeight * 40,
                    ),

                    // enter email textbox
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: "Email",
                        filled: true,
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(color: Colors.white),
                        ),
                      ),
                      validator: (val) => val.isEmpty ? 'enter email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),

                    // spacing
                    SizedBox(
                      height: 5,
                    ),

                    // enter password textbox
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Password',
                        filled: true,
                        fillColor: Colors.white,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10.0),
                          borderSide: new BorderSide(),
                        ),
                      ),
                      validator: (val) => val.length < 6
                          ? 'enter a password atleast 6 characters long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),

                    // spacing
                    SizedBox(
                      height: 10,
                    ),

                    // email login button
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 120,
                      ),
                      color: Colors.yellow,
                      child: Text(
                        'Login',
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // button pressed
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .signInWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = 'please use valid credentials';
                              loading = false;
                            });
                          } else {
                            Navigator.pop(context);
                          }
                        }
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
                      height: 5,
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

                    FlatButton(
                      child: Expanded(
                        child: Text(
                          'Dont have an account? Signup',
                          overflow: TextOverflow.clip,
                          maxLines: 1,
                          softWrap: false,
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                      onPressed: () {
                        print("register");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return new SignUpIntro();
                        }));
                      },
                    ),

                    FlatButton(
                      child: Expanded(
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(color: Colors.white, fontSize: 13.0),
                        ),
                      ),
                      onPressed: () {
                        print("forgot pswrd");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return new Forgot();
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
