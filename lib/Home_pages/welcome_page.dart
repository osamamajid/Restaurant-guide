import 'package:flutter/material.dart';

import '../utils/onbording.dart';
import 'login page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://as1.ftcdn.net/v2/jpg/01/29/75/62/1000_F_129756209_jzrdjAiwfZjqsN2kZ49hkoRHkVfO3Wnc.jpg'),
            // Background image path
            fit: BoxFit.cover, // Cover the entire area with the background image
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OnBoarding()),
                  );
                },
                child: Text('Go to Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
