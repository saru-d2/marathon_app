import 'package:flutter/material.dart';
import 'package:marathon/shared/constants.dart';

class Forgot extends StatefulWidget {
  @override
  _ForgotState createState() => _ForgotState();
}

class _ForgotState extends State<Forgot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("media/images/Login.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: Form(
            // key:

            child: Center(
              child: Column(
                children: <Widget>[
                  // spacing
                  SizedBox(
                    height: ScreenConstants.percentHeight * 30,
                  ),

                  Text(
                    'Forgot Password',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // spacing
                  SizedBox(
                    height: 20,
                  ),

                  Text(
                    'Enter your email or username and we will send you instructions on how to reset your password.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // spacing
                  SizedBox(
                    height: 20,
                  ),

                  // enter email/username
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Email/username",
                      filled: true,
                      fillColor: Colors.white,
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10.0),
                        borderSide: new BorderSide(color: Colors.white),
                      ),
                    ),
                    validator: (val) => val.isEmpty ? 'enter email' : null,
                    onChanged: (val) {
                      //  setState(() => email = val);
                    },
                  ),

                  // spacing
                  SizedBox(
                    height: 20,
                  ),

                  RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      padding: EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 150,
                      ),
                      color: Colors.yellow,
                      child: Text(
                        'Send',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // button pressed
                      onPressed: () async {
                        // TODO: implement stuff
                      }),
                ],
              ),
            ),
          )),
    );
  }
}
