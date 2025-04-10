
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/view/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context)=>HomeScreen()  ));
    });

  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.sizeOf(context).height;
    var width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/news.jfif',
          fit: BoxFit.cover,
            width: width,
            height: height/2,
          ),
          SizedBox(
            height: height*.05,
          ),
          Text('HEADLINE NEWS',style: GoogleFonts.anton(
            letterSpacing: 2,
            fontSize: 20,
            color: Colors.blueAccent
          ),),
          SizedBox(
            height: height*.05,
          ),
          SpinKitDualRing(
            color: Colors.blueAccent,
            size: 60,
          )
        ],
      ),
    );
  }
}
