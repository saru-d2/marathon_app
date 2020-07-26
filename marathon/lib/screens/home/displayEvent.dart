// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marathon/shared/loading.dart';

class displayEvents extends StatefulWidget {
  final String eventID;
  displayEvents({Key key, @required this.eventID}) : super(key: key);
  @override
  _displayEventsState createState() => _displayEventsState();
}

class _displayEventsState extends State<displayEvents> {
  var docData;
  Map<String, dynamic> documentData;
  var eName;
  var loading = true;
  
  void initState() {
    super.initState();
    getDoc();
  }

  void getDoc() async {
    // var d =
    //     await Firestore.instance.collection('events').document(widget.eventID);
    // d.get().then((DocumentSnapshot) =>
    //     print(DocumentSnapshot.data['eventName'].toString()));
    print("hello");
    await Firestore.instance
        .collection('events')
        .where("document_id", isEqualTo: widget.eventID.toString())
        .getDocuments()
        .then((event) {
          print("wow");
      if (event.documents.isNotEmpty) {
        print("hiiyah");
        documentData = event.documents.single.data;
        print(documentData["eventName"]);
        
        setState(() {
          docData = documentData;
        });
      } else {
        print("empty");
      }
    }).catchError((e) => print("error fetching data: $e"));
  }

  @override
  Widget build(BuildContext context) {
    // return (docData == null)
    //     ? Loading()
    //     : Scaffold(
            return Scaffold(
            appBar: AppBar(
              title: Text("dispEvnt"),
            ),
            body: Column(
              children: [
                RaisedButton(onPressed: () {
                  print(documentData);
                })
              ],
            ),
          );
  }
}
