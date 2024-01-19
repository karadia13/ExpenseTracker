import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'adminopreations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(0xff746bc9),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      debugShowCheckedModeBanner: false,
      // home: StreamBuilder(
      // stream: FirebaseAuth.instance.authStateChanges()
      // builder: (context, sanpshot){
      // if (snapshot.hasData){
      //    return HomePage();
      // } else{
      //   return Login();
      // }
      // },
      // },
      home: AdminHome(),
    );
  }
}
