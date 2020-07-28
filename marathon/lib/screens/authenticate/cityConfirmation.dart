import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:latlong/latlong.dart';

class ConfirmationPage extends StatefulWidget {
  ConfirmationPage();
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  final Distance distance = new Distance();

  Position _currentPosition;
  String _currentAddress = "", _currentCity = "", _currentCityId="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Confirm City"),
        ),
        body: StreamBuilder(
          stream: Firestore.instance.collection("cities").snapshots(),
          builder: (context, snapshots) {
            _getCurrentLocation();
            if(_currentAddress!="")
            {
              List<DocumentSnapshot> cityList = snapshots.data.documents
                          .where((DocumentSnapshot documentSnapshot) => (/*(_currentAddress.toLowerCase().contains(documentSnapshot['cityName'].toLowerCase())) && */(distance(new LatLng(_currentPosition.latitude, _currentPosition.longitude), new LatLng(documentSnapshot["geoLocation"].latitude, documentSnapshot["geoLocation"].longitude)) < 150000 ? true : false))).toList();
              
              if(cityList.length>0)
              {
                  _currentCity=cityList.first["cityName"];
                  _currentCityId=cityList.first.documentID;
              }
            }
            if (snapshots.hasData) {
              print(_currentCityId);
              print(_currentAddress);
              return Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              _currentCity=="" ?
              <Widget>[
                Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              ),
              ]
              :
              <Widget>[
                Text("City: " + _currentCity),
                SizedBox(height: 30,),
                RaisedButton(
                child: Text("Confirm"),
                onPressed: (){

                },
                ),
                RaisedButton(
                child: Text("Retry"),
                onPressed: (){
                  setState(() {
                    _currentCity="";
                    _currentAddress="";
                  });
                  _getCurrentLocation();
                },
                ),
              ]
              ),
        );
            } else {
              return Align(
                alignment: FractionalOffset.bottomCenter,
                child: CircularProgressIndicator(),
              );
            }
          }),);
  }
   _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.subAdministrativeArea}";
      });
    } catch (e) {
      print(e);
    }
  }
}

