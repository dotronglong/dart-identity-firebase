import 'package:firebase_auth/firebase_auth.dart';
import 'package:identity/identity.dart';

import 'firebase_user_converter.dart';
import 'snackbar_notifier.dart';

class IdentityFirebaseProvider extends IdentityProvider {
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
}
