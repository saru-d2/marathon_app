import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  String _name = '';
  String _gender = 'select gender';
  String _email = '';
  String _password = '';
  String _conPassword = '';
  String error = '';
  DateTime dateCreated;
  String _age;
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
              title: Text('Register'),
              actions: <Widget>[
                FlatButton.icon(
                    onPressed: () {
                      widget.toggleView();
                    },
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
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Name'),
                      validator: (val) => val.isEmpty ? 'enter name' : null,
                      onChanged: (val) {
                        setState(() => _name = val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Email'),
                      validator: (val) => val.isEmpty ? 'enter email' : null,
                      onChanged: (val) {
                        setState(() => _email = val);
                      },
                    ),
                    // SizedBox(height: 20,),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Password'),
                      validator: (val) => val.length < 6
                          ? 'enter a password atleast 6 characters long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => _password = val);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'Confirm Password'),
                      validator: (val) => val.length < 6
                          ? 'enter a password atleast 6 characters long'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => _conPassword = val);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton <String>(
                      value: _gender,
                      // validator: (val) => val != 'select gender' ? 'select gender' : null,
                      onChanged: (String newVal) {
                        setState(() {
                          _gender = newVal;
                        });
                      },
                      items: <String>['select gender', 'male', 'female', 'other'].map<DropdownMenuItem<String>> ((String val){
                        return DropdownMenuItem<String>(
                          value: val,
                          child: Text(val),
                          );
                      }).toList()
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'age'),
                      validator: (val) => val.length < 1
                          ? 'enter your age'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => _age = val);
                      },
                    ),
                    RaisedButton(
                      color: Colors.pink[400],
                      child: Text(
                        'Sign Up',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() => loading = true);
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(_email, _password);
                          if (result == null) {
                            setState(() {
                              error = 'please supply a valid email';
                              loading = false;
                            });
                            
                          }
                          else {
                            Firestore.instance.collection('users').document().setData({
                              'name': _name,
                              'age': _age,
                              'uid': result.uid,
                              'time_added': DateTime.now(),
                              'email': _email,
                            });
                          }
                        }
                      },
                    ),
                    // RaisedButton(
                    //   onPressed: () {
                    //     print(gender);
                    //   },
                    // ),
                    SizedBox(
                      height: 20,
                    ),
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
