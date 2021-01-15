import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:voting_system/screens/home/user/user_ongoing_tile.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class UserOngoing extends StatefulWidget {
  @override
  _UserOngoingState createState() => _UserOngoingState();
}

class _UserOngoingState extends State<UserOngoing> {
  final DatabaseService _db = DatabaseService();
  int unvoted = 0;
  bool checkIfAlreadyVoted(List<dynamic> list) {
    String uid = FirebaseAuth.instance.currentUser.uid;
    int i = 0;
    list.forEach((str) {
      if (str.toString() == uid) {
        i = 1;
      }
    });
    return i == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal * 1.5),
      child: StreamBuilder(
        stream: _db.activePolls,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0
                ? Center(child: Text("No Ongoing Polls"))
                : Container(
                    child: ListView.builder(
                      itemCount: snapshot.data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == snapshot.data.length) {
                          return unvoted == 0
                              ? Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.safeBlockHorizontal * 20),
                                  child: Text(
                                    "Looks like there are no ongoing polls right now. \n \n (The results will be visible after admin closes the polls)",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.only(
                                      top: SizeConfig.safeBlockHorizontal * 20),
                                  child: Text(
                                    "(The results will be visible after admin closes the polls)",
                                    textAlign: TextAlign.center,
                                  ),
                                );
                        } else {
                          if (!checkIfAlreadyVoted(
                              snapshot.data[index].voteBy)) {
                            unvoted++;
                            return UserOngoingTile(poll: snapshot.data[index]);
                          } else {
                            return Container();
                          }
                        }
                      },
                    ),
                  );
          } else {
            return Loading();
          }
        },
      ),
    );
  }
}
