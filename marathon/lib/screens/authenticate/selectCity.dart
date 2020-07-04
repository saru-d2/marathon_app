import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:marathon/screens/authenticate/selectChapter.dart';

class selectCity extends StatefulWidget {
  final String uid;
  @override
  selectCity(this.uid, {Key key}) : super(key: key);

  _selectCityState createState() => _selectCityState();
}

class Data {
  String uid;
  String cityName;
  String docId;

  Data({this.cityName, this.docId, this.uid});
}

class _selectCityState extends State<selectCity> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select city"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance.collection("cities").snapshots(),
          builder: (context, snapshots) {
            if (snapshots.hasData) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];
                    return Card(
                        key: Key(documentSnapshot["city"]),
                        child: Card(
                          elevation: 4,
                          margin: EdgeInsets.all(8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            title:
                                Text(documentSnapshot['cityName'].toString()),
                            onTap: () {
                              final data = Data(
                                cityName:
                                    documentSnapshot['cityName'].toString(),
                                docId: documentSnapshot.documentID.toString(),
                                uid: widget.uid,
                              );

                              print("butt");
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return new selectChapter(data);
                              }));
                            },
                          ),
                        ));
                  });
            } else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
