import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tempheart/screens/login_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      routes: {
        'login': (BuildContext context) => LoginPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Kraken Global',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: LoginPage()
    );
  }
}


