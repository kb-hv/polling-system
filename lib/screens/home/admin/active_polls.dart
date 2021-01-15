import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/screens/home/admin/poll_details.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class ActivePolls extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(SizeConfig.safeBlockVertical),
      // setting up a stream to get all ongoing polls (isCompleted = false)
      child: StreamBuilder(
        stream: _db.activePolls,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data.length == 0 ? Center(child:Text("No Active Polls", style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2),)): Container(
              child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return PollTile(poll: snapshot.data[index]);
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

class PollTile extends StatelessWidget {
  final DatabaseService _db = DatabaseService();
  final   Poll poll;
  PollTile({this.poll});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: SizeConfig.safeBlockVertical * 1/5, color: Color(0xFFD4E4E7)),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureProvider<List<Choice>>.value(
                value: _db.getChoices(poll.docID),
                child: PollDetails(poll: poll),
              ),
            ),
          );
        },
        child: Text(poll.title, style: TextStyle(color: Colors.black, fontSize: SizeConfig.safeBlockVertical * 2.3),),
      ),
    );
  }
}