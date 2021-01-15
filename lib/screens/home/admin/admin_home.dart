import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voting_system/screens/home/admin/active_polls.dart';
import 'package:voting_system/screens/home/admin/new_poll.dart';
import 'package:voting_system/screens/home/shared/closed_polls.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/shared/size_config.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  AuthService _auth = AuthService();
  String _appbarTitle = 'Admin Home';
  int _currentIndex = 0;
  final widgetList = [ActivePolls(), ClosedPolls()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appbarTitle,
            style: TextStyle(
                color: Colors.black,
                fontSize: SizeConfig.safeBlockVertical * 3,
                letterSpacing: 3)),
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
                          child: Text(
                            "LOGOUT",
                            style: TextStyle(color: Colors.black),
                          ),
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
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          elevation: 10.0,
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
                label: "History")
          ],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              if (index == 0) {
                _appbarTitle = 'Polls';
              } else {
                _appbarTitle = 'Poll History';
              }
            });
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // open a create polls screen
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NewPoll()));
        },
        label: Text(
          'Create Poll',
          style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5),
        ),
      ),
    );
  }
}
