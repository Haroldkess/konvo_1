import 'package:flutter/material.dart';
import 'package:konvo_1/screens/signup_screen.dart';
import 'package:konvo_1/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      // Logging in the user w/ Firebase
      AuthService.login(_email, _password);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Konvo',
                style: TextStyle(
                  fontFamily: 'Billabong',
                  fontSize: 50.0,
                  color: Colors.yellow
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(labelText: 'Email',labelStyle: TextStyle(color: Colors.white),),
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                        onSaved: (input) => _email = input,
                        cursorColor: Colors.white,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 30.0,
                        vertical: 10.0,
                      ),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),

                        decoration: InputDecoration(labelText: 'Password',labelStyle: TextStyle(color: Colors.white),hoverColor: Colors.white),
                        validator: (input) => input.length < 6
                            ? 'Must be at least 6 characters'
                            : null,
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        cursorColor: Colors.white,

                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 400.0,
                      child: FlatButton(
                        onPressed: _submit,
                        color: Colors.black,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Container(
                      width: 400.0,
                      child: FlatButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, SignupScreen.id),
                        color: Colors.black,
                        padding: EdgeInsets.all(10.0),
                        child: Text(
                          'Signup',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
