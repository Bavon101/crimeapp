import 'package:crimeapp/Contollers/AppState.dart';
import 'package:crimeapp/Contollers/FireDataQ.dart';
import 'package:crimeapp/Views/Home.dart';
import 'package:crimeapp/Views/SignIn.dart';
import 'package:crimeapp/Views/Splash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:provider/provider.dart';

import 'Contollers/FireGoogleService.dart';
import 'Contollers/Navigation.dart';

late FireData fireData;
 final FireGoogleService service = FireGoogleService();
main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseApp app = await Firebase.initializeApp();
  fireData = new FireData(app: app);
  fireData.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
      ],
      child: Phoenix(
      child: MyApp(),
    ),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 5)),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.grey,
              ),
              debugShowCheckedModeBanner: false,
              home: SplashScreen());
        } else {
          User? user = FirebaseAuth.instance.currentUser;
          return MaterialApp(
              // showSemanticsDebugger: false,
              debugShowCheckedModeBanner: false,
              title: 'Crime map',
              routes: Navigate.routes,
              theme: ThemeData(
                primarySwatch: Colors.grey,
              ),
              home: user != null ? Home() : SignIn());
        }
      },
    );
  }
}
