import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/screens/home/shared/radio_list.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class Vote extends StatelessWidget {
  final Poll poll;
  Vote({this.poll});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Choice> choices = Provider.of<List<Choice>>(context);
    return choices == null
        ? Loading()
        : Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 3,
                    horizontal: SizeConfig.safeBlockHorizontal * 3),
                child: Column(
                  children: [
                    Text(
                      poll.title,
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 4,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 1.5,
                    ),
                    Text(
                      poll.description,
                      style:
                          TextStyle(fontSize: SizeConfig.safeBlockVertical * 2),
                    ),
                    CustomRadio(pollID: poll.docID),
                  ],
                ),
              ),
            ),
          );
  }
}
