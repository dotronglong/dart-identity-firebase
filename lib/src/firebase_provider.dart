import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sso/sso.dart';

import 'email_authenticator.dart';

class FirebaseProvider extends Provider {
  FirebaseProvider(
      [List<Authenticator> authenticators = const [EmailAuthenticator()]])
      : super(authenticators);

  @override
  Future<User> start() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return convert(user);
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

  static Future<User> convert(FirebaseUser user) async {
    if (user == null) {
      return null;
    }

    Map data = Map();
    data[User.KEY_ID] = user.uid;
    data[User.KEY_EMAIL] = user.email;
    data[User.KEY_IS_VERIFIED] = user.isEmailVerified;
    data[User.KEY_IS_ENABLED] = true;

    if (user.isEmailVerified == true) {
      IdTokenResult idTokenResult = await user.getIdToken(refresh: true);
      data[User.KEY_TOKEN] = idTokenResult.token;
      data[User.KEY_EXPIRED_AT] = idTokenResult.expirationTime;
    }

    return User(data);
  }
}
