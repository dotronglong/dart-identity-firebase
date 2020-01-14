import 'package:firebase_auth/firebase_auth.dart';
import 'package:sso/sso.dart';

class FirebaseUserConverter implements UserConverter {
  @override
  Future<User> convert(dynamic resource) async {
    if (resource == null) {
      return null;
    }
    assert(resource is FirebaseUser);
    FirebaseUser user = (resource as FirebaseUser);

    Map data = Map();
    data[User.KEY_ID] = user.uid;
    data[User.KEY_EMAIL] = user.email;
    data[User.KEY_IS_ENABLED] = true;
    data[User.KEY_IS_VERIFIED] =
        user.providerData.last.providerId == EmailAuthProvider.providerId
            ? user.isEmailVerified
            : true;

    if (data[User.KEY_IS_VERIFIED] == true) {
      IdTokenResult idTokenResult = await user.getIdToken(refresh: true);
      data[User.KEY_TOKEN] = idTokenResult.token;
      data[User.KEY_EXPIRED_AT] = idTokenResult.expirationTime;
    }

    return User(data);
  }
}
