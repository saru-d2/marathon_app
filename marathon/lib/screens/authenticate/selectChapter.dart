import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:marathon/screens/authenticate/selectCity.dart';

class selectChapter extends StatefulWidget {
  final Data info;
  selectChapter(this.info, {Key key}) : super(key: key);

  @override
  _selectChapterState createState() => _selectChapterState();
}

class _selectChapterState extends State<selectChapter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("select chapter"),
      ),
      body: StreamBuilder(
          stream: Firestore.instance
              .collection("cities")
              .document(widget.info.docId)
              .collection("chapters")
              .snapshots(),
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
                            title: Text(
                                documentSnapshot['chapterName'].toString()),
                            onTap: () {
                              print("buttockss");
                              print(widget.info.uid);
                              Firestore.instance
                                  .collection("users")
                                  .document(widget.info.uid)
                                  .setData({
                                'chapter':
                                    documentSnapshot['chapterName'].toString(),
                                'city': widget.info.cityName,
                              }, merge: true);

                              Navigator.pop(context);
                              
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
