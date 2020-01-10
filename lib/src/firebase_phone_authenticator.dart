import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:identity/identity.dart';
import 'package:sso/sso.dart';

import 'firebase_provider.dart';
import 'phone_signin_page.dart';

class FirebasePhoneAuthenticator with WillNotify implements Authenticator {
  FirebasePhoneAuthenticator();

  @override
  WidgetBuilder get action => (context) => ActionButton(
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => PhoneSignInPage(this))),
      color: Color.fromRGBO(0, 166, 96, 1),
      textColor: Colors.white,
      icon: Icon(
        Icons.phone_iphone,
        color: Color.fromRGBO(0, 166, 96, 1),
      ),
      text: "Sign In With Phone");

  @override
  Future<void> authenticate(BuildContext context, [Map parameters]) async {
    assert(parameters != null);
    assert(parameters["code"] != null);
    assert(parameters["verification_id"] != null);
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: parameters["verification_id"],
      smsCode: parameters["code"],
    );
    return authenticateWithCredential(context, credential);
  }

  Future<void> authenticateWithCredential(
      BuildContext context, AuthCredential credential) {
    return FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((result) => FirebaseProvider.convert(result.user))
        .then((user) => Identity.of(context).user = user)
        .catchError(Identity.of(context).error);
  }

  Future<void> send(BuildContext context, String phoneNumber,
      {Duration timeout = const Duration(seconds: 5)}) {
    return FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: timeout,
        verificationCompleted: (AuthCredential credential) =>
            authenticateWithCredential(context, credential),
        verificationFailed: (AuthException authException) {
          notifier.notify(context,
              'Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
        },
        codeSent: (String verificationId, [int forceResendingToken]) =>
            _navigateToPhoneVerificationPage(
                context, phoneNumber, verificationId),
        codeAutoRetrievalTimeout: (String verificationId) =>
            _navigateToPhoneVerificationPage(
                context, phoneNumber, verificationId));
  }

  void _navigateToPhoneVerificationPage(
      BuildContext context, String phoneNumber, String verificationId) {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                PhoneVerificationPage(this, phoneNumber, verificationId)));
  }
}
