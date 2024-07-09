import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restaurant_menu/Home_pages/otpscreen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController phoneNumberController = TextEditingController();
  bool _buttonIsActive = false; // Define _buttonIsActive here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.phone,
              controller: phoneNumberController,
              maxLength: 11,
              decoration: InputDecoration(

                  labelText: 'رقم الهاتف',
                floatingLabelAlignment: FloatingLabelAlignment.center,
                prefixIcon: const Icon(Icons.phone),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  // Check if the entered phone number has exactly 11 digits
                  if (value.length == 11) {
                    _buttonIsActive = true;
                  } else {
                    _buttonIsActive = false;
                  }
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 0.0,
                foregroundColor: _buttonIsActive ? Colors.white : const Color(0xFF91A5B2),
                backgroundColor: _buttonIsActive ? Color(0xFF0E71B0) : const Color(0xFFE1EAF0),
                minimumSize: const Size(200, 35),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              onPressed: _buttonIsActive
                  ? () async {
                String phoneNumber = phoneNumberController.text.trim();
                print('Phone number entered: $phoneNumber');

                await FirebaseAuth.instance.verifyPhoneNumber(
                  phoneNumber: phoneNumber,
                  verificationCompleted: (PhoneAuthCredential credential) {
                    // Handle verification completion if needed
                  },
                  verificationFailed: (FirebaseAuthException ex) {
                    // Handle verification failure if needed
                  },
                  codeSent: (String verificationId, int? resendToken) {
                    // Navigate to OTP screen and pass phone number and verificationId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(
                          phoneNumber: phoneNumber,
                          verificationId: verificationId,
                        ),
                      ),
                    );
                  },
                  codeAutoRetrievalTimeout: (String verificationId) {
                    // Handle timeout if needed
                  },
                );
              }
                  : null,
              child: const Text('تسجيل'),
            ),

            SizedBox(height: 15),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              Container(
                height: 2,
                width: 100,
                child: Divider(
                  thickness: 1,
                  height: BorderSide.strokeAlignOutside,
                  endIndent: 2,
                  indent: 2,

                ),
              ),
              Text('OR Sign in with',style: TextStyle(color: Colors.grey,fontSize: 13),),
              Container(
                height: 2,
                width: 100,
                child: Divider(
                  thickness: 1,
                  height: BorderSide.strokeAlignOutside,
                  endIndent: 2,
                  indent: 2,
                ),
              ),
            ],),
            // const Divider(
            //   thickness: 1,
            //   height: BorderSide.strokeAlignOutside,
            //   endIndent: 50,
            //   indent: 50,
            // ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    // Handle Facebook login
                  },
                  icon: const Icon(FontAwesomeIcons.facebook, color: Colors.blue, size: 35),
                ),
                IconButton(
                  onPressed: () {
                    // Handle Google login
                  },
                  icon: const Icon(FontAwesomeIcons.google, color: Colors.red, size: 35),
                ),
                IconButton(
                  onPressed: () {
                    // Handle Apple login
                  },
                  icon: const Icon(FontAwesomeIcons.apple, color: Colors.grey, size: 35),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
