import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marathon/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _auth = AuthService();
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
                var name = a.data["displayname"];
                print(name);
              },
            )
          ],
        ),
      ),
    );
  }
}
