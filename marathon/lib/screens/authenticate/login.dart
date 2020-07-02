import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/sign_in.dart';
import 'package:marathon/screens/authenticate/landing.dart';
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

                    // enter email textbox
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'enter email' : null,
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),

                    // spacing
                    SizedBox(
                      height: 20,
                    ),

                    // enter password textbox
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
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
                      height: 20,
                    ),

                    // email login button
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign In',
                        style: TextStyle(color: Colors.white),
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
                          }
                          else {
                            Navigator.pop(context);
                          }
                        }
                      },
                    ),


                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red, fontSize: 14.0),
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
                    FlatButton(
                      child: Text('Not a member? Sign up!'),
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
