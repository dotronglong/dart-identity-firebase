import 'package:firebase_auth/firebase_auth.dart';
import 'package:sso/sso.dart';

Future<User> getUser(FirebaseUser user) async {
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
