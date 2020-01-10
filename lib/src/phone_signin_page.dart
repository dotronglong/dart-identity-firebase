import 'package:flutter/material.dart';

import 'firebase_phone_authenticator.dart';

class PhoneSignInPage extends StatefulWidget {
  final FirebasePhoneAuthenticator authenticator;

  const PhoneSignInPage(this.authenticator, {Key key}) : super(key: key);

  @override
  State createState() => _PhoneSignInPageState();
}

class _PhoneSignInPageState extends State<PhoneSignInPage> {
  TextEditingController _controllerPhoneNumber =
      TextEditingController(text: "+");
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;

  String get label => "Sign In With Phone";

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
                  child: Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        TextFormField(
                          keyboardType: TextInputType.phone,
                          autofocus: true,
                          readOnly: _isLoading,
                          style: TextStyle(fontSize: 32, letterSpacing: 2),
                          decoration: InputDecoration(
                              labelText: 'Phone number',
                              labelStyle: TextStyle(fontSize: 20)),
                          validator: (String value) {
                            if (value.isEmpty || !value.startsWith("+")) {
                              return 'Phone number (+x xxx-xxx-xxxx)';
                            }
                            return null;
                          },
                          controller: _controllerPhoneNumber,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: RaisedButton.icon(
                            icon: Icon(Icons.send),
                            onPressed: _isLoading
                                ? null
                                : () async {
                                    if (_form.currentState.validate()) {
                                      if (this.mounted) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                      }
                                      await widget.authenticator.send(
                                          context, _controllerPhoneNumber.text);
                                      if (this.mounted) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                      }
                                    }
                                  },
                            label: const Text('Send Code'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}

class PhoneVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;
  final FirebasePhoneAuthenticator authenticator;

  const PhoneVerificationPage(
      this.authenticator, this.phoneNumber, this.verificationId,
      {Key key})
      : super(key: key);

  @override
  State createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  TextEditingController _controllerCode = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        readOnly: _isLoading,
                        style: TextStyle(fontSize: 32, letterSpacing: 2),
                        decoration: InputDecoration(
                            labelText: 'Code',
                            labelStyle: TextStyle(fontSize: 20)),
                        controller: _controllerCode,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton.icon(
                          icon: Icon(Icons.check_circle_outline),
                          onPressed: _isLoading
                              ? null
                              : () async {
                                  if (this.mounted) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                  }
                                  await widget.authenticator.authenticate(
                                      context, {
                                    "verification_id": widget.verificationId,
                                    "code": _controllerCode.text
                                  });
                                  if (this.mounted) {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  }
                                },
                          label: const Text('Proceed'),
                        ),
                      ),
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
}
