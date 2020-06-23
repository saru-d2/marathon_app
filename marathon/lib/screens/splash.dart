import 'package:flutter/material.dart';
import 'package:marathon/models/user.dart';
import 'package:marathon/screens/authenticate/authenticate.dart';
import 'package:marathon/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    //return either home or authen
    if(user==null){
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}
