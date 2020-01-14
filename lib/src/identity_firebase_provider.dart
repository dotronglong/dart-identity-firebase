import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:identity/identity.dart';
import 'package:sso/sso.dart';

import 'firebase_user_converter.dart';
import 'snackbar_notifier.dart';

class IdentityFirebaseProvider extends Provider {
  IdentityFirebaseProvider([List<Authenticator> authenticators = const []])
      : super(authenticators, SnackBarNotifier(), FirebaseUserConverter());

  @override
  Future<User> start() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return convert(user);
  }

  @override
  Future<void> stop() {
    return FirebaseAuth.instance.signOut();
  }

  static Future<void> init(BuildContext context,
      List<Authenticator> authenticators, WidgetBuilder success) {
    Provider provider = IdentityFirebaseProvider(authenticators ?? []);
    return Identity.of(context).init(provider, success,
        builder: (context) => SignInPage(provider,
            header: Container(
              margin: EdgeInsets.only(top: 16, bottom: 32),
              child: Image.asset(
                "images/firebase.png",
                package: 'identity_firebase',
                width: 64,
                height: 64,
              ),
            )));
  }
}
