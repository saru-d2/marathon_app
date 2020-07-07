import 'package:flutter/material.dart';
import 'package:marathon/models/user.dart';
import 'package:marathon/screens/authenticate/landing.dart';
import 'package:marathon/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    //return either home or authen
    
    print(user);
    if (user == null) {
      return Landing();
    } else {
      // Navigator.pop(context);
      return Home();
    }
  }
}
