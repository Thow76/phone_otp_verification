// ignore_for_file: deprecated_member_use

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:phone_otp_verification/screens/home_screen.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // variable
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  // variable
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  FirebaseAuth _auth = FirebaseAuth.instance;

  String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        showLoading = false;
      });

      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(e.code)));
    }
  }

  // methods
  getMobileFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: otpController,
          decoration: InputDecoration(
            hintText: " Phone Number",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            setState(() {
              showLoading = true;
            });
            await _auth.verifyPhoneNumber(
              phoneNumber: phoneController.text,
              verificationCompleted: (PhoneAuthCredential) async {
                setState(() {
                  showLoading = false;
                });
                //signInWithPhoneAuthCredential(PhoneAuthCredential);
              },
              verificationFailed: (verificationFailed) async {
                setState(() {
                  showLoading = false;
                });
                Scaffold.of(context).showSnackBar(
                    SnackBar(content: Text(verificationFailed.message)));
              },
              codeSent: (verificationId, resendingToken) async {
                setState(() {
                  showLoading = false;
                  currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
                  this.verificationId = verificationId;
                });
              },
              codeAutoRetrievalTimeout: (verificationId) async {},
            );
          },
          child: Text("VERIFY"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  getOtpFormWidget(context) {
    return Column(
      children: [
        Spacer(),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            hintText: " Enter OTP ",
          ),
        ),
        SizedBox(
          height: 16,
        ),
        FlatButton(
          onPressed: () async {
            final PhoneAuthCredential = PhoneAuthProvider.credential(
                verificationId: verificationId, smsCode: otpController.text);

            signInWithPhoneAuthCredential(PhoneAuthCredential);
          },
          child: Text("SEND"),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Spacer(),
      ],
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: showLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                ? getMobileFormWidget(context)
                : getOtpFormWidget(context),
        padding: const EdgeInsets.all(16),
      ),
    );
  }
}
