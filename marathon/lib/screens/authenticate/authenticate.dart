import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:marathon/screens/authenticate/register.dart';
import 'package:marathon/screens/authenticate/sign_in.dart';
import 'package:marathon/shared/constants.dart';
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/loading.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  final AuthService _auth = AuthService();
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  bool loading = false;
  @override
  Widget build(BuildContext context) {
    ScreenConstants().init(context);
    // if(showSignIn){
    //   return Container(
    //     child: SignIn(toggleView : toggleView),
    //   );
    // }
    // else{
    //   return Container(
    //     child: Register(toggleView : toggleView),
    //   );
    // }
    return loading
        ? Loading
        : Scaffold(
            backgroundColor: Colors.blue,
            body: Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment. center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: ScreenConstants.percentHeight * 50,
                  ),
                  SignInButton(
                    Buttons.Google,
                    onPressed: () async {
                      print("google");
                      dynamic result = await _auth.signInWithGoogle();
                    },
                  ),
                  SignInButton(
                    Buttons.Facebook,
                    onPressed: () {
                      print("facebook");
                    },
                  ),
                  Text('or'),
                  SignInButton(Buttons.Email, onPressed: () {
                    print("email");
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return new SignIn();
                    }));
                  }),
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
            ));
  }
}
