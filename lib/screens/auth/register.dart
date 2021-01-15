import 'package:flutter/material.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class Register extends StatefulWidget {
  Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String username = "";
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value) && value.length >= 8;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 0, horizontal: SizeConfig.safeBlockVertical * 2.5),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 15,
                    ),
                    Text(
                      'REGISTER',
                      style: TextStyle(
                          fontSize: SizeConfig.safeBlockVertical * 3,
                          letterSpacing: SizeConfig.safeBlockVertical),
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(() {
                          username = val;
                        });
                      },
                      validator: (val) => val.isEmpty ? 'Enter username' : null,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.black,
                          )),
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      validator: (val) => val.isEmpty ? 'Enter email' : null,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 3,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          )),
                      obscureText: true,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                      validator: (val) => !validateStructure(val)
                          ? 'at least 8 chars, 1 spl char, 1 number, 1 caps'
                          : null,
                    ),
                    SizedBox(
                      height: SizeConfig.safeBlockVertical * 4,
                    ),
                    RaisedButton(
                      elevation: 0,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            loading = true;
                          });
                          dynamic result =
                              await _auth.registerWithEmailAndPassword(
                                  email, password, username);

                          if (result == null) {
                            setState(() {
                              loading = false;
                              error = 'invalid email';
                            });
                          }
                        }
                      },
                      // color: Colors.purple[500],

                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 2),
                      ),
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical * 3),
                    Text(
                      error,
                      style: TextStyle(color: Colors.red),
                    ),
                    SizedBox(height: SizeConfig.safeBlockVertical * 2),
                    InkWell(
                      child: Padding(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.safeBlockVertical * 2.5),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2.5),
                        ),
                      ),
                      onTap: () {
                        widget.toggleView();
                      },
                    )
                  ],
                ),
              ),
            ),
          ));
  }
}
