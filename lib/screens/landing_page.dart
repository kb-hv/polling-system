import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/screens/auth/auth_wrapper.dart';
import 'package:voting_system/screens/auth/verify_email.dart';
import 'package:voting_system/screens/home/home_wrapper.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/services/db.dart';

class LandingPage extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  final AuthService _auth = AuthService();

  Widget build(BuildContext context) {
    // getting the value from stream provider
    User user = Provider.of<User>(context);

    if (user != null) {
      // signed in
      if (!_auth.checkEmailVerification()) {
        // signed in user did not verify email
        return VerifyEmail();
      } else {
        // signed in user verified email
        Future.delayed(const Duration(seconds: 1));
        return FutureProvider<bool>(
          create: (context) {
            return _db.isUserAdmin();
          },
          child: HomeWrapper(),
        );
      }
    } else {
      // no user, not signed in
      return AuthWrapper();
    }
  }
}
