import 'package:flutter/material.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/shared/size_config.dart';

class ChoiceCard extends StatelessWidget {
  final int index;
  final Choice choice;
  ChoiceCard({this.choice, this.index});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      // margin: EdgeInsets.only(bottom: SizeConfig.safeBlockVertical),
      child: Theme(
        data: Theme.of(context).copyWith(accentColor: Colors.black),
        child: ExpansionTile(
          title: Text(
            choice.title,
            style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.3),
          ),
          children: [
            Text(
              "Description: " + choice.description,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical,
            ),
            Text(
              "Votes: " + choice.votes.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2),
            ),
            SizedBox(
              height: SizeConfig.safeBlockVertical,
            )
          ],
        ),
      ),
    );
  }
}
