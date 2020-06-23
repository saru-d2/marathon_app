import 'package:flutter/material.dart';
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/constants.dart';
import 'package:marathon/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {



  String email ='';
  String password = '';
  String error = '';
  bool loading = false;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        title: Text('Register'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: (){widget.toggleView();},
              icon: Icon(Icons.person),
              label: Text("Sign In"))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Email'),
                validator: (val) => val.isEmpty ? 'enter email' : null,
                onChanged: (val){
                  setState(() => email = val);
                },
              ),
              SizedBox(height: 20,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Password',),
                validator: (val) => val.length < 6 ? 'enter a password atleast 6 characters long' : null,
                obscureText: true,
                onChanged: (val){
                  setState(() => password = val);
                },),
              SizedBox(height: 20,),
              RaisedButton(
                color: Colors.pink[400],
                child: Text(
                  'Sign Up',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if(_formKey.currentState.validate()){
                    setState(() => loading = true);
                    dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                    if(result==null){
                      setState(() {
                        error = 'please supply a valid email';
                        loading = false;
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 20,),
              Text(
                error,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
