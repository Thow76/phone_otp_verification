import 'package:flutter/material.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variable
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  // methods
  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          decoration: InputDecoration(
            hintText: " Phone Number",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () {},
          child: Text("Verify"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
            ? getMobileFormWidget(context)
            : getOtpFormWidget(context),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
