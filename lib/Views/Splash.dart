import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: WIDTH(context: context)*.55,
              child: LinearProgressIndicator()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Starting Crime',style: TextStyle(
                color: Colors.black,
                letterSpacing: 1.2
              ),),
            ),

          ],
        ),
      ),
    );
  }
}