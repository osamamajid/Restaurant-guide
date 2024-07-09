import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_menu/Home_pages/welcome_page.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  final String verificationId;

  const OtpScreen({
    Key? key,
    required this.phoneNumber,
    required this.verificationId,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  late Timer _timer;
  int _start = 10;
  final pinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void resendOtp() {
    setState(() {
      _start = 10; // Reset the timer
      startTimer(); // Restart the timer
      // Implement OTP resend logic here
      // You can add your API call or any logic to resend OTP
      print('Resending OTP...');

      // Show a notification or message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('OTP Resent!'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = _buildPinTheme();

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Verification',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 40),
            Text(
              'Enter the code sent to ${widget.phoneNumber}',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            Center(
              child: Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: defaultPinTheme.decoration!.copyWith(
                    border: Border.all(color: Colors.lightGreen),
                  ),
                ),
                submittedPinTheme: defaultPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                keyboardType: TextInputType.number,
                controller: pinController,
                onCompleted: (pin) {
                  // Handle completed pin input
                  print(pin);
                  signInWithOTP(pin);
                },
              ),
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Resend OTP in $_start seconds',
                      style: TextStyle(color: Colors.redAccent),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0.0,
                        // Customize button colors based on _start
                        foregroundColor:
                        _start == 0 ? Colors.white : const Color(0xFF91A5B2),
                        backgroundColor:
                        _start == 0 ? Color(0xFF0E71B0) : const Color(0xFFE1EAF0),
                        minimumSize: const Size(120, 35),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      onPressed: _start == 0 ? resendOtp : null,
                      child: Text('Resend'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void signInWithOTP(String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } catch (e) {
      print('Error: $e');
      // Handle sign-in errors here
    }
  }

  PinTheme _buildPinTheme() {
    return PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: Colors.transparent),
      ),
    );
  }
}
