import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/shared/size_config.dart';

class VerifyEmail extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: 0, horizontal: SizeConfig.safeBlockHorizontal * 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Please check your email for the verfication link',
              style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 3),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.safeBlockVertical * 2),
              child: Text(
                "I verified",
                style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 3),
              ),
              onPressed: () async {
                await _auth.signOut();
                Fluttertoast.showToast(
                    msg: "Please sign in to continue",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    backgroundColor: Colors.black,
                    textColor: Colors.white);
              },
            )
          ],
        ),
      ),
    );
  }
}
