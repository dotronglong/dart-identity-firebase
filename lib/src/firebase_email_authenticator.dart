import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identity/identity.dart';
import 'package:sso/sso.dart';

import 'email_signin_page.dart';

class FirebaseEmailAuthenticator with WillConvertUser implements Authenticator {
  FirebaseEmailAuthenticator();

  @override
  WidgetBuilder get action => (context) => ActionButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => EmailSignInPage(this))),
      color: Color.fromRGBO(93, 16, 74, 1),
      textColor: Colors.white,
      icon: Icon(
        Icons.email,
        color: Colors.white,
      ),
      text: "Sign in with Email");

  @override
  Future<void> authenticate(BuildContext context, [Map parameters]) async {
    _validate(parameters);
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: parameters["email"], password: parameters["password"])
        .then((result) => convert(result.user))
        .then((user) => Identity.of(context).user = user)
        .catchError(Identity.of(context).error);
  }

  Future<void> register(BuildContext context, [Map parameters]) async {
    _validate(parameters);
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: parameters["email"], password: parameters["password"])
        .then((result) async {
          if (result.user.isEmailVerified == false) {
            await result.user.sendEmailVerification();
          }

          return convert(result.user);
        })
        .then((user) => Identity.of(context).user = user)
        .catchError(Identity.of(context).error);
  }

  void _validate(Map parameters) {
    assert(parameters != null);
    assert(parameters["email"] != null);
    assert(parameters["password"] != null);
  }
}
