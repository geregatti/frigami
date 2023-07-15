import 'dart:async';
import 'package:flutter/material.dart';
import 'package:frigami/pages/welcomePage.dart';
import 'package:frigami/pages/loginNew.dart';

class LogoPage extends StatefulWidget {
  @override
  _LogoPageState createState() => _LogoPageState();
}

class _LogoPageState extends State<LogoPage> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 3), ()   {
      // Navigate to different screens based on conditions
        //Navigator.push(
          //        context,
            //      PageRouteBuilder(
              //      transitionDuration: Duration(milliseconds: 500),
              //      pageBuilder: (_, __, ___) => NewLogin(),
              //      transitionsBuilder: (_, animation, __, child) {
              //        return ScaleTransition(
              //          scale: animation,
              //          child: child,
              //        );
              //      },
              //    ),
            //    );
          //MaterialPageRoute(builder: (context) => NewLogin());
        Navigator.push(context, MaterialPageRoute(builder: (context) => NewLogin()),);
      });
    }
  


@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('assets/logo.png'), // Replace with your image path
      ),
    );
  }
}