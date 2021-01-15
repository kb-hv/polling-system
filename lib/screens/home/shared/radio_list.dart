import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/models/radio.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/size_config.dart';

class CustomRadio extends StatefulWidget {
  final String pollID;
  CustomRadio({this.pollID});
  @override
  _CustomRadioState createState() => _CustomRadioState();
}

class _CustomRadioState extends State<CustomRadio> {
  List<RadioModel> options = [];
  DatabaseService _db = DatabaseService();

  String selectedID = "";

  @override
  Widget build(BuildContext context) {
    List<Choice> choices = Provider.of<List<Choice>>(context);
    int n = choices.length;
    choices.forEach((candidate) {
      options.add(RadioModel(
          title: candidate.title,
          description: candidate.description,
          isSelected: false,
          id: candidate.choiceID));
    });

    return Container(
      padding: EdgeInsets.only(top: SizeConfig.safeBlockVertical * 2),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: choices.length + 1,
        itemBuilder: (context, index) {
          return index == choices.length
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.safeBlockHorizontal * 3,
                      vertical: SizeConfig.safeBlockVertical * 2),
                  child: RaisedButton(
                    color: Color(0xFFD4E4E7),
                    child: Padding(
                      padding: EdgeInsets.all(SizeConfig.safeBlockVertical),
                      child: Text(
                        "VOTE",
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 2.5),
                      ),
                    ),
                    onPressed: () async {
                      if (selectedID != "") {
                        showDialog(
                            context: context,
                            builder: (BuildContext dialogContext) {
                              return AlertDialog(
                                title: Text(
                                  "Are you sure?",
                                ),
                                content: Text(
                                  "You will not be able to change your vote later.",
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
                                    onPressed: () async {
                                      await _db.vote(widget.pollID, selectedID);
                                      Fluttertoast.showToast(
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          msg: "Voted",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER);
                                      Navigator.pop(dialogContext);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "VOTE",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            });
                      } else {
                        Fluttertoast.showToast(
                          backgroundColor: Colors.black,
                          textColor: Colors.white,
                          msg: "Select a Candidate",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.CENTER,
                        );
                        //TODO: toast message

                      }
                    },
                  ),
                )
              : InkWell(
                  // customBorder: RoundedRectangleBorder(
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  splashColor: Colors.blueAccent,
                  onTap: () {
                    setState(() {
                      options.forEach((tile) => tile.isSelected = false);
                      options[index].isSelected = true;
                      selectedID = options[index].id;
                    });
                  },
                  child: RadioItem(item: options[index]),
                );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel item;
  RadioItem({this.item});
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      margin: EdgeInsets.all(
        SizeConfig.safeBlockVertical * 2,
      ),
      child: Padding(
        padding: EdgeInsets.all(SizeConfig.safeBlockVertical),
        child: Column(
          children: [
            Text(
              item.title,
              style: TextStyle(
                  color: item.isSelected ? Colors.black : Colors.grey),
            ),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: item.isSelected ? Colors.black : Colors.grey),
            )
          ],
        ),
      ),
      decoration: BoxDecoration(
        border: Border.all(
            color: item.isSelected ? Colors.black : Colors.grey[300]),
        color: item.isSelected ? Colors.grey[300] : Colors.grey[100],
      ),
    );
  }
}
// D5E8E8
// F6FAFA
// D4E4E7
// B3CFD5
