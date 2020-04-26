import 'package:flutter/material.dart';
import 'package:identity/identity.dart';

import 'firebase_email_authenticator.dart';

class EmailSignInPage extends StatefulWidget {
  final Authenticator authenticator;

  const EmailSignInPage(this.authenticator, {Key key}) : super(key: key);

  @override
  State createState() => _EmailSignInPageState();
}

class _EmailSignInPageState extends State<EmailSignInPage> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();
  bool _isSignIn = true;
  bool _isLoading = false;

  get label => _isSignIn ? 'Sign In' : 'Sign Up';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Builder(builder: (context) {
        return Container(
          color: Theme.of(context).primaryColorDark,
          padding: EdgeInsets.all(16),
          child: Center(
            child: Card(
              child: Container(
                padding: EdgeInsets.all(16),
                width: double.infinity,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      TextField(
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(labelText: 'Email'),
                        controller: _controllerEmail,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(labelText: 'Password'),
                        controller: _controllerPassword,
                      ),
                      _getSubmitButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _getSubmitButton(BuildContext context) {
    return _isLoading
        ? Container(
            margin: EdgeInsets.only(top: 16),
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: CircularProgressIndicator(),
          )
        : Container(
            margin: EdgeInsets.only(top: 16),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                    width: double.infinity,
                    child: RaisedButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        final Map parameters = {
                          "email": _controllerEmail.text,
                          "password": _controllerPassword.text
                        };
                        setState(() {
                          _isLoading = true;
                        });
                        if (_isSignIn) {
                          await this
                              .widget
                              .authenticator
                              .authenticate(context, parameters);
                        } else if (this.widget.authenticator
                            is FirebaseEmailAuthenticator) {
                          await (this.widget.authenticator
                                  as FirebaseEmailAuthenticator)
                              .register(context, parameters);
                        } else {
                          assert(this.widget.authenticator
                              is FirebaseEmailAuthenticator);
                        }
                        if (this.mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                      child: Text(label),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    )),
                _getSwitchFormButton()
              ],
            ),
          );
  }

  Widget _getSwitchFormButton() {
    return FlatButton(
        onPressed: () {
          if (this.mounted) {
            setState(() {
              _isSignIn = !_isSignIn;
            });
          }
        },
        child: Text(_isSignIn
            ? "Don't have account? Sign Up now"
            : "Already registered? Sign In now"));
  }
}
