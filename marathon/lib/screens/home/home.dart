import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marathon/screens/authenticate/selectCity.dart';
import 'package:marathon/screens/home/displayEvent.dart';
import 'package:marathon/services/auth.dart';
import 'package:marathon/shared/loading.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  @override
  var pic;
  var fbUser;
  var dbUser;

  bool loading = true;
  void initState() {
    print("hi");
    super.initState();
    getUserInfo();
    // getUserfromDb();
  }

  void getUserInfo() async {
    print("heyo");
    var u = await _auth.getUser();
    setState(() {
      // fbUser = await _auth.getUser();
      fbUser = u;
      print("fbUser: $fbUser");
    });
    getUserfromDb();
  }

  void getUserfromDb() async {
    print("hiii");
    var u =
        await Firestore.instance.collection("users").document(fbUser.uid).get();
    setState(() {
      pic = u.data["photoUrl"];
      print(pic);
    });
    setState(() {
      dbUser = u;
    });
    while (dbUser == null) loading = true;
    loading = false;
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
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
                    label: Text('logout')),
                CircleAvatar(
                  backgroundImage:
                      NetworkImage(dbUser.data["photoUrl"].toString()),
                  radius: 30,
                )
              ],
            ),
            body: Container(
              child: Column(
                children: [
                  Container(
                    child: Text(dbUser.data["city"].toString()),
                  ),
                  Container(
                    child: Text(dbUser.data["chapter"].toString()),
                  ),
                  RaisedButton(
                    child: Text("select city"),
                    onPressed: () {
                      print("city");
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return new selectCity(dbUser.data["uid"].toString());
                      }));
                    },
                  ),
                  RaisedButton(
                    color: Colors.amber,
                    onPressed: () {
                      setState(() {});
                      getUserfromDb();
                    },
                  ),
                  new EventList(),
                ],
              ),
            ),
            bottomNavigationBar:
                BottomNavigationBar(items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                title: Text("home"),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.explore),
                title: Text("explore"),
              ),
              // BottomNavigationBarItem(icon: null)
            ]),
          );
  }
}

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Firestore.instance.collection('events').snapshots(),
      builder: (context, snapshots) {
        if (snapshots.hasData) {
          return Container(
            height: 200,
            child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: snapshots.data.documents.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot documentSnapshot =
                      snapshots.data.documents[index];
                  return Container(
                    width: 130,
                    child: ListTile(
                      title: Text(documentSnapshot['eventName']),
                      onTap: () {
                        print("heyy");
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => displayEvents(eventID: documentSnapshot.documentID.toString(),)));
                      },
                    ),
                  );
                }),
          );
        }
      },
    );
  }
}
