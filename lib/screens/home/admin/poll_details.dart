import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/screens/home/admin/choice_card.dart';
import 'package:voting_system/screens/home/admin/vote_resolve.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class PollDetails extends StatefulWidget {
  final Poll poll;
  final Choice winner;
  PollDetails({@required this.poll, this.winner});

  @override
  _PollDetailsState createState() => _PollDetailsState();
}

class _PollDetailsState extends State<PollDetails> {
  bool _closingLoad = false;
  final DatabaseService _db = DatabaseService();

  Future<List<Choice>> _tiedChoiceList(List<Choice> choice) async {
    List<Choice> tiedChoices = [];
    int maxVotes = await _db
        .getPopularChoice(widget.poll.docID)
        .then((value) => value.votes);
    choice.forEach((choice) {
      if (choice.votes == maxVotes) {
        tiedChoices.add(choice);
      }
    });
    return tiedChoices;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    List<Choice> choices = Provider.of<List<Choice>>(context);
    if (choices == null) return Loading();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.poll.title, style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 3, letterSpacing: 2),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(SizeConfig.safeBlockVertical),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              Text(
                widget.poll.description,
                textAlign: TextAlign.center,
                  style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5)
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              Container(
                child: Column(
                  children: choices
                      .map((choice) => ChoiceCard(
                          index: choices.indexOf(choice), choice: choice))
                      .toList(),
                ),
              ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 3,
              ),
              RaisedButton(
                padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 1.5),
                      child: Text("Close Poll", style: TextStyle(fontSize: SizeConfig.safeBlockVertical * 2.5),),
                      onPressed: () async {
                        setState(() {
                          _closingLoad = true;
                        });
                        if (await _db.candidateDraws(widget.poll.docID)) {
                          List<Choice> tiedChoices =
                              await _tiedChoiceList(choices);
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                      "It looks like some candidates have the same number of votes"),
                                  elevation: 24.0,
                                  content: Text("You need to cast your vote before closing. Click NEXT."),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          _closingLoad = false;
                                        });
                                        Navigator.pop(context);

                                      },
                                      child: Text("CANCEL", style: TextStyle(color: Colors.grey),),
                                    ),
                                    FlatButton(
                                      onPressed: () {
                                        setState(() {
                                          _closingLoad = false;
                                        });
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => VoteResolve(widget.poll, tiedChoices)));
                                      },
                                      child: Text("NEXT", style: TextStyle(color: Colors.black),),
                                    ),
                                  ],
                                );
                              });
                        } else {
                          _db.changePollStatus(widget.poll.docID);
                          Fluttertoast.showToast(
                            textColor: Colors.white,
                            backgroundColor: Colors.black,
                            msg: "Poll Closed",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                          );
                          Navigator.pop(context);
                        }
                      },
                    ),
              SizedBox(
                height: SizeConfig.safeBlockVertical * 4,
              ),
              Visibility(
                  visible: _closingLoad,
                  child: Text(
                    "Please wait...",
                  ))
            ],
          ),
        ),
      ),
    );
  }
}