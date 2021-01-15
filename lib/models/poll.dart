import 'package:flutter/cupertino.dart';

class Poll {
  final String title;
  final String description;
  List<Choice> choices;
  String popularChoice;
  String docID;
  final bool isClosed;
  List<dynamic> voteBy;
  Poll(
      {this.isClosed,
      this.title,
      this.popularChoice,
      this.choices,
      this.description,
      this.docID,
      this.voteBy});
}

class Choice {
  final String title;
  final String description;
  final String choiceID;
  int votes;
  Choice({this.description, this.title, this.votes, @required this.choiceID});
}
