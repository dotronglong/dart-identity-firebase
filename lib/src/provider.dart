import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sso/sso.dart';

import 'email_authenticator.dart';
import 'helpers.dart';

class FirebaseProvider extends Provider {
  FirebaseProvider(
      [List<Authenticator> authenticators = const [EmailAuthenticator()]])
      : super(authenticators);

  @override
  Future<User> start() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return getUser(user);
  }

  @override
  Future<void> stop() {
    return FirebaseAuth.instance.signOut();
  }

  @override
  Widget get header => Container(
        margin: EdgeInsets.only(top: 16, bottom: 32),
        child: Image.asset(
          "images/firebase.png",
          package: 'identity_firebase',
          width: 64,
          height: 64,
        ),
      );

  @override
  ThemeData get theme => null;
}
