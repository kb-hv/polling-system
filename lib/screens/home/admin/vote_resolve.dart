import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/screens/home/shared/vote.dart';

class VoteResolve extends StatelessWidget {
  final Poll poll;
  final List<Choice> choice;
  VoteResolve(this.poll, this.choice);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<List<Choice>>.value(
          value: choice,
          child: Vote(poll: poll,)
      ),
    );
  }
}
