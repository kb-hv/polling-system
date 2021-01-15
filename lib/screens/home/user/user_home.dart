import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voting_system/screens/home/shared/closed_polls.dart';
import 'package:voting_system/screens/home/user/user_ongoing.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/shared/size_config.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  AuthService _auth = AuthService();
  String _appbarTitle = 'User Home';
  int _currentIndex = 0;
  final widgetList = [UserOngoing(), ClosedPolls()];
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _appbarTitle,
          style: TextStyle(
              color: Colors.black,
              fontSize: SizeConfig.safeBlockVertical * 3,
              letterSpacing: 3),
        ),
        centerTitle: true,
        actions: [
          FlatButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(
                        "Are you sure you want to logout?",
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "CANCEL",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        FlatButton(
                          onPressed: () async {
                            await _auth.signOut();
                            Fluttertoast.showToast(
                              backgroundColor: Colors.black,
                              textColor: Colors.white,
                              msg: "Successfully logged out",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              //
                              //
                            );
                            Navigator.pop(context);
                          },
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    );
                  });
            },
            child: Icon(
              Icons.exit_to_app,
              color: Colors.black,
              size: SizeConfig.safeBlockVertical * 3.5,
            ),
          )
        ],
      ),
      body: widgetList.elementAt(_currentIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.white)]),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          elevation: 70.0,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.how_to_vote,
                  size: SizeConfig.safeBlockVertical * 2.5,
                ),
                label: "Polls"),
            BottomNavigationBarItem(
                icon: Icon(Icons.update,
                    size: SizeConfig.safeBlockVertical * 2.5),
                label: "Closed")
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                _appbarTitle = 'Active Polls';
              } else {
                _appbarTitle = 'Closed Polls';
              }
            });
          },
        ),
      ),
    );
  }
}
