import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class ConfirmationPage extends StatefulWidget {
  ConfirmationPage();
  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;

  Position _currentPosition;
  String _currentAddress = "";

  @override
  Widget build(BuildContext context) {
    _getCurrentLocation();
    return Scaffold(
        appBar: AppBar(
          title: Text("Confirm City"),
        ),
        body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text("City: " + _currentAddress),
                SizedBox(height: 30,),
                RaisedButton(
                child: Text("Confirm"),
                onPressed: (){

                },
                )
              ]),
        ));
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


