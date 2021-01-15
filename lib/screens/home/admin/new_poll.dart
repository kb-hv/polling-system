import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voting_system/models/poll.dart';
import 'package:voting_system/services/db.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class NewPoll extends StatefulWidget {
  @override
  _NewPollState createState() => _NewPollState();
}

class _NewPollState extends State<NewPoll> {
  DatabaseService _db = DatabaseService();
  String choiceError = "";
  String error = "";
  String title;
  String description;
  List<Choice> choices = [];
  String choiceTitle;
  String choiceDescription;
  final _formKey = GlobalKey<FormState>();
  final _choiceFormKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                "New Poll",
                style: TextStyle(
                    fontSize: SizeConfig.safeBlockVertical * 3,
                    letterSpacing: 2),
              ),
              elevation: 2,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: SizeConfig.safeBlockVertical * 4,
                    horizontal: SizeConfig.safeBlockHorizontal * 3),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: InputDecoration(labelText: "Title"),
                        onChanged: (val) {
                          title = val;
                        },
                        validator: (val) => val.isEmpty ? "enter title" : null,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 2,
                      ),
                      TextFormField(
                        decoration: InputDecoration(labelText: "Description"),
                        onChanged: (val) {
                          description = val;
                        },
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: 5,
                        validator: (val) =>
                            val.isEmpty ? "enter description" : null,
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 2,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                            child: Text("Add option"),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text("Choice Details"),
                                    elevation: 24.0,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Form(
                                          key: _choiceFormKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextFormField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    choiceTitle = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                    labelText: "Title"),
                                                validator: (val) => val.isEmpty
                                                    ? "enter title"
                                                    : null,
                                              ),
                                              SizedBox(
                                                height: SizeConfig
                                                    .safeBlockVertical,
                                              ),
                                              TextFormField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    choiceDescription = val;
                                                  });
                                                },
                                                keyboardType:
                                                    TextInputType.multiline,
                                                minLines: 1,
                                                maxLines: 5,
                                                decoration: InputDecoration(
                                                    labelText: "Description"),
                                                validator: (val) => val.isEmpty
                                                    ? "enter description"
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          if (_choiceFormKey.currentState
                                              .validate()) {
                                            setState(() {
                                              Choice choice = Choice(
                                                  title: choiceTitle,
                                                  description:
                                                      choiceDescription);
                                              choices.add(choice);
                                            });
                                            Fluttertoast.showToast(
                                              backgroundColor: Colors.black,
                                              textColor: Colors.white,
                                              msg: "Choice added",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                            );
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          Text("Choices: " + choices.length.toString())
                        ],
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 2,
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            if (choices.length > 1) {
                              setState(() {
                                choiceError = "";
                                error = "";
                                loading = true;
                              });
                              Poll poll = Poll(
                                  choices: choices,
                                  title: title,
                                  description: description);
                              await _db.createPoll(poll);
                              Fluttertoast.showToast(
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                msg: "Poll Created",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                              );
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                choiceError = "Enter atleast two choices";
                              });
                            }
                          }
                        },
                        child: Text('Create Poll'),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 2,
                      ),
                      Text(choiceError, style: TextStyle(color: Colors.red))
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
