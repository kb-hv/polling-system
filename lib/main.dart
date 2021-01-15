import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/screens/landing_page.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/shared/size_config.dart';

// D5E8E8
// F6FAFA
// D4E4E7
// B3CFD5

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return MaterialApp(
      home: StreamProvider.value(
        value: AuthService().user,
        child: LandingPage(),
      ),
      theme: ThemeData(
        accentColor: Color(0xFFFFFFFF),
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        primaryColor: Color(0xFFD4E4E7),
        fontFamily: "Nunito",
        scaffoldBackgroundColor: Color(0xFFFFFFFF),
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFFD4E4E7),
          shape: RoundedRectangleBorder(),
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          contentPadding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1.5),
          hintStyle: TextStyle(fontFamily: "Nunito", color: Color(0xFF000000)),
          labelStyle: TextStyle(fontFamily: "Nunito", color: Color(0xFF000000)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical),
            borderSide: BorderSide(color: Color(0xFFD4E4E7)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]),
            borderRadius: BorderRadius.circular(SizeConfig.safeBlockVertical),
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedItemColor: Color(0xFF000000),
          unselectedItemColor: Colors.grey,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFD4E4E7),
        ),
      ),
    );
  }
}
