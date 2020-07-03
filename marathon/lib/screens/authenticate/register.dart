import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marathon/screens/authenticate/selectCity.dart';
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
  dynamic _profilePic = null;

  void getPic() async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _profilePic = img;
      print("hehe");
    });
  }

  void uploadPic(uid) async {
    if (_profilePic == null) {
      print("no photo");
    } else {
      final StorageReference ref =
          FirebaseStorage.instance.ref().child('/assets/profilepics/$uid.png');
      final StorageUploadTask task = ref.putFile(_profilePic);
      // print('$uid.png');
      // Future picurl = (await ref.getDownloadURL());
      String downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      Firestore.instance.collection("users").document(uid).setData({
        'photoUrl': downloadUrl.toString(),
      }, merge: true);
    }
  }

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
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        print("profile button");
                        getPic();
                      },
                      elevation: 2.0,

                      // fillColor: Colors.white,
                      child: Icon(
                        Icons.person_outline,
                        size: 35.0,
                      ),
                      padding: EdgeInsets.all(15.0),
                      shape: CircleBorder(),
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
                      validator: (val) => _conPassword != _password
                          ? 'Passwords do not match'
                          : null,
                      obscureText: true,
                      onChanged: (val) {
                        setState(() => _conPassword = val);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    
                    TextFormField(
                      decoration: InputDecoration(hintText: 'age'),
                      validator: (val) {
                        try {
                          int okay = int.parse(val);
                          if (okay < 18) {
                            return 'you must atleast be 18';
                          }
                          if (okay > 200) {
                            return 'We know you are not that old';
                          }
                          return null;
                        } catch (e) {
                          return 'enter a valid age';
                        }
                      },
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
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  _email, _password, _age, _name);
                          if (result == null) {
                            setState(() {
                              error = 'please supply a valid email';
                              loading = false;
                            });
                          } else {
                            Navigator.pop(context);
                            uploadPic(result.uid);
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              print("in nav");
                              return new selectCity();
                            }));
                          }
                        }
                      },
                    ),
                    RaisedButton(
                      onPressed: () {
                        // print(gender);
                        // uploadPic();
                      },
                    ),
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
