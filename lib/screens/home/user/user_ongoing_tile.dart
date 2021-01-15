import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/screens/home/shared/vote.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/size_config.dart';

class UserOngoingTile extends StatefulWidget {
  final Poll poll;
  UserOngoingTile({this.poll});

  @override
  _UserOngoingTileState createState() => _UserOngoingTileState();
}

class _UserOngoingTileState extends State<UserOngoingTile> {
  final DatabaseService _db = DatabaseService();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
              width: SizeConfig.safeBlockHorizontal * 2 / 5,
              color: Color(0xFFD4E4E7)),
        ),
      ),
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FutureProvider<List<Choice>>.value(
                value: _db.getChoices(widget.poll.docID),
                child: Vote(poll: widget.poll),
              ),
            ),
          );
        },
        child: Text(widget.poll.title,
            style: TextStyle(
                color: Color(0xFF000000),
                fontSize: SizeConfig.safeBlockVertical * 2.5)),
      ),
    );
  }
}
