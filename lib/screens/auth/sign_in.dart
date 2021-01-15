import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:voting_system/services/auth.dart';
import 'package:voting_system/shared/loading.dart';
import 'package:voting_system/shared/size_config.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  AuthService _auth = AuthService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String resetEmail = "";
  String email = "";
  String password = "";
  String error = "";
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return loading
        ? Loading()
        : Scaffold(
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 0,
                    horizontal: SizeConfig.safeBlockHorizontal * 5),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 15,
                      ),
                      Text(
                        'SIGN IN',
                        style: TextStyle(
                            fontSize: SizeConfig.safeBlockVertical * 3,
                            letterSpacing: SizeConfig.safeBlockVertical),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 4,
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
                        validator: (val) =>
                            val.isEmpty ? 'Enter password' : null,
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
                            dynamic result = await _auth
                                .signInWithEmailAndPassword(email, password);
                            if (result == null) {
                              setState(() {
                                loading = false;
                                error = 'invalid credentials';
                              });
                            }
                          }
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2),
                        ),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      Text(
                        error,
                        style: TextStyle(color: Colors.red[600]),
                      ),
                      SizedBox(height: SizeConfig.safeBlockVertical * 3),
                      InkWell(
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: SizeConfig.safeBlockVertical * 2),
                          child: Text(
                            "Register",
                            style: TextStyle(
                                fontSize: SizeConfig.safeBlockVertical * 2.5),
                          ),
                        ),
                        onTap: () {
                          widget.toggleView();
                        },
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical * 3,
                      ),
                      InkWell(
                        child: Text(
                          "Forgot Password?",
                          style: TextStyle(
                              fontSize: SizeConfig.safeBlockVertical * 2),
                        ),
                        onTap: () {
                          if (email == "") {
                            Fluttertoast.showToast(
                                backgroundColor: Colors.black,
                                textColor: Colors.white,
                                msg: "Enter your email",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER);
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text(
                                    "Password Reset",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize:
                                            SizeConfig.safeBlockVertical * 2),
                                  ),
                                  content: RichText(
                                    text: TextSpan(
                                      text:
                                          "The password reset email will be sent to ",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize:
                                              SizeConfig.safeBlockVertical * 2),
                                      children: [
                                        TextSpan(
                                          text: email,
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize:
                                                  SizeConfig.safeBlockVertical *
                                                      2),
                                        ),
                                        TextSpan(
                                          text: ". Click OK to proceed",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize:
                                                  SizeConfig.safeBlockVertical *
                                                      2),
                                        )
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    FlatButton(
                                      child: Text(
                                        "OK",
                                      ),
                                      onPressed: () async {
                                        Fluttertoast.showToast(
                                          msg:
                                              "Check your email for instructions",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                        );
                                        await _auth.resetPassword(email);
                                        Navigator.pop(context);
                                      },
                                    )
                                  ],
                                );
                              },
                            );
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
