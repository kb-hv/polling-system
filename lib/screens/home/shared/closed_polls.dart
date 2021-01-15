import 'package:flutter/material.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class ClosedPolls extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return StreamBuilder(
      stream: _db.inactivePolls,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return snapshot.data.length == 0
              ? Padding(
                  padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 10),
                  child: Center(
                      child: Text("No Closed Polls",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2))),
                )
              : Container(
                  child: ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (context, index) {
                      return ClosedTile(poll: snapshot.data[index]);
                    },
                  ),
                );
        } else {
          return Loading();
        }
      },
    );
  }
}

class ClosedTile extends StatelessWidget {
  final Poll poll;
  ClosedTile({this.poll});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal),
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFD4E4E7)),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockHorizontal),
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical,
              ),
              Text(
                poll.title.toUpperCase(),
                style: TextStyle(
                  fontSize: SizeConfig.safeBlockVertical * 2,
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 2,
              ),
              Text(
                'Result: ' + poll.popularChoice,
                style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 1.8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
