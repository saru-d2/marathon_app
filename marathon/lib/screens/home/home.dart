import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marathon/services/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  var pic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        title: Text('title'),
        backgroundColor: Colors.brown[400],
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text('logout'))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            RaisedButton(
              child: Text('hullo'),
              onPressed: () async {
                var user = await _auth.getUser();
                print(user.uid);
                // print("${user.uid}.png");
                var a = await Firestore.instance
                    .collection("users")
                    .document(user.uid)
                    .get();
                var name = a.data["photoUrl"];
                print(a.data["displayname"]);
                setState(() {
                  pic = name;
                });
              },
            ),
            Container(
              child: pic == null
                  ? Text("no pic")
                  : Image.network(
                      pic,
                      height: 120,
                      width: 120,
                    ),
            )
          ],
        ),
      ),
    );
  }
}
