import 'dart:convert';
import 'dart:developer';

import 'package:crimeapp/Contollers/AppState.dart';
import 'package:crimeapp/Contollers/ShortCalls.dart';
import 'package:crimeapp/Models/CrimesModel.dart';
import 'package:crimeapp/Views/AddCrimeView.dart';
import 'package:crimeapp/Widgets/CrimeTotals.dart';
import 'package:crimeapp/Widgets/CrimesViewCard.dart';
import 'package:crimeapp/Widgets/MapView.dart';
import 'package:crimeapp/Widgets/SignOutButton.dart';
import 'package:crimeapp/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late User user;

  @override
  void initState() {
    super.initState();
    // delay for build to complete
    setState(() {
      user = FirebaseAuth.instance.currentUser!;
    });

    Future.delayed(Duration(milliseconds: 1000), () {
      Provider.of<AppState>(context, listen: false).getUserCurrentLocation();
      Provider.of<AppState>(context, listen: false).getCrimes();
      Provider.of<AppState>(context, listen: false).startListeningToCrimes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return Scaffold(
        body: Stack(children: [
          MapsProvider(),
          Positioned(
            top: HEIGHT(context: context)*.05,
            right: 15,
            child: SignOutButton()),
            Positioned(
               top: HEIGHT(context: context) * .05,
               left: 15,
              child: CrimeTotals(total: appState.crimes.length,))
        ]),
        floatingActionButton: FloatingActionButton(
          tooltip: 'report a crime',
          onPressed: () {
            // goes to crime page
            if (appState.selectedCrime != null) {
              appState.updateSelectedCrime(crime: null);
            } else {
              goto(context: context, child: AddCrimeView(user: user));
            }
          },
          child: Icon(
              appState.selectedCrime != null ? Icons.close_rounded : Icons.add),
        ),
        bottomSheet: appState.selectedCrime != null
            ? CrimeCardView(crime: appState.selectedCrime!)
            : null,
      );
    });
  }
}
