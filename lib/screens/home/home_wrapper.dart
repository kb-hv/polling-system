import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/screens/home/admin/admin_home.dart';
import 'package:voting_system/screens/home/user/user_home.dart';
import 'package:voting_system/shared/loading.dart';

class HomeWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // get isAdmin value from provider
    bool isUserAdmin = Provider.of<bool>(context);
    if (isUserAdmin == null) {
      return Loading();
    }
    return isUserAdmin ? AdminHome() : UserHome();
  }
}