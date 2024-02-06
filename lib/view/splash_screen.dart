import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:newsapp/view/authentication.dart';
import 'package:newsapp/view/homeScreen.dart';

class splash_screen extends StatefulWidget {
  const splash_screen({super.key});

  @override
  State<splash_screen> createState() => _splash_screenState();
}

class _splash_screenState extends State<splash_screen> {

// =========================================================== 
//this is initial point to enter the application so, initial splash screen show for few second so, it is used .
//super.initState(); is a way to call the initState method of the superclass (the parent class) of your 
//custom stateful widget.
//===========================================================
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => 
        const authForm(),
      ));
    });
  }


  @override
  Widget build(BuildContext context) {

// MediaQuery.of(context) is a way to access information about the device's screen and the current app's context in Flutter.
//* 1 doing nothing mathematically multiplied by 1 remains the same

    final height = MediaQuery.sizeOf(context).height * 1;
    final width = MediaQuery.sizeOf(context).width * 1;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
                    'assets/images/Animation - 1707216873842.json',// Replace with the path to your Lottie animation JSON file
                    width: 200,
                    height: 200,
                    // Other properties like repeat, reverse, etc., can be added here
                  ),
//             Image.asset(
//               'assets/images/splash_screen.jpg',
//               fit: BoxFit.cover,
//  // In Flutter, the line width: width * 0.9, is setting the width of a widget to 90% of its current width. Let me break it down:
//               width: width * .9,
//               height: height * .5,
//             ),
            SizedBox(
              height: height * 0.04,
            ),
            Text(
              'TOP HEADLINES',
              style: GoogleFonts.anton(letterSpacing: 0.6),
            ),
            SizedBox(
              height: height * 0.04,
            ),
//SpinKitChasingDots which provides a collection of loading indicators (spinners)
            const SpinKitDoubleBounce(
              color: Colors.blue,
              size: 40,
            )
          ],
        ),
      ),
    );
  }
}
