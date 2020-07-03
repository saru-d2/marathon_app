import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
            // backgroundColor: Colors.brown[100],
            // appBar: AppBar(
            //   backgroundColor: Colors.brown[400],
            //   elevation: 0.0,
            //   title: Text('Register'),
            //   actions: <Widget>[
            //     FlatButton.icon(
            //         onPressed: () {
            //           widget.toggleView();
            //         },
            //         icon: Icon(Icons.person),
            //         label: Text("Sign In"))
            //   ],
            // ),
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
                child: Center(
                  child: Column(
                    children: <Widget>[
                      // spacing
                      SizedBox(
                        height: 20,
                      ),
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
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(15.0),
                        shape: CircleBorder(),
                      ),
                      // spacing
                      SizedBox(
                        height: 10,
                      ),

                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Name',
                          filled: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'enter name' : null,
                        onChanged: (val) {
                          setState(() => _name = val);
                        },
                      ),
                      // spacing
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) => val.isEmpty ? 'enter email' : null,
                        onChanged: (val) {
                          setState(() => _email = val);
                        },
                      ),
                      // spacing
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
                        validator: (val) => val.length < 6
                            ? 'enter a password atleast 6 characters long'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() => _password = val);
                        },
                      ),
                      // spacing
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
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
                      DropdownButton<String>(
                          value: _gender,
                          style: TextStyle(
                            color: Colors.black,
                            backgroundColor: Colors.white,
                          ),
                          // validator: (val) => val != 'select gender' ? 'select gender' : null,
                          onChanged: (String newVal) {
                            setState(() {
                              _gender = newVal;
                            });
                          },
                          items: <String>[
                            'Select Gender',
                            'male',
                            'female',
                            'other'
                          ].map<DropdownMenuItem<String>>((String val) {
                            return DropdownMenuItem<String>(
                              value: val,
                              child: Text(val),
                            );
                          }).toList()),
                      // spacing
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: 'Age',
                          filled: true,
                          fillColor: Colors.white,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                            borderSide: new BorderSide(color: Colors.white),
                          ),
                        ),
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
                      // spacing
                      SizedBox(
                        height: 20,
                      ),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 80,
                        ),
                        color: Colors.yellow,
                        child: Text(
                          'Sign up with Email',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            //fontWeight: FontWeight.bold,
                          ),
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
                            }
                          }
                        },
                      ),
                      // RaisedButton(
                      //   onPressed: () {
                      //     // print(gender);
                      //     // uploadPic();
                      //   },
                      // ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // Text(
                      //   error,
                      //   style: TextStyle(color: Colors.red, fontSize: 14.0),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
