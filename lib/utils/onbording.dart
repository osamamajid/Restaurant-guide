import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';
import 'package:flutter_restaurant_menu/Home_pages/login%20page.dart';

class OnBoarding extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: OnBoardingSlider(
        headerBackgroundColor: Colors.white,
        finishButtonText: 'Login',
        finishButtonStyle: FinishButtonStyle(
          backgroundColor: Colors.black,
         ),
        skipTextButton: Text('Skip', style: TextStyle(color: Colors.black)),
        trailing: Text('Login', style: TextStyle(color: Colors.black)),
        background: [
          Image.asset('assets/images/background.jpg', fit: BoxFit.cover,width:screenWidth * 0.8,height: screenheight * 0.2,),
          Image.asset('assets/images/background.jpg', fit: BoxFit.contain,width: screenWidth ,height: screenheight,),
          Image.asset('assets/images/background.jpg', fit: BoxFit.contain,width: screenWidth ,height: screenheight,),
          Image.asset('assets/images/background.jpg', fit: BoxFit.contain,width: screenWidth ,height: screenheight,),
        ],
        totalPage: 4,
        speed: 1.8,
        pageBodies: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 480),
                Text('Description Text 1'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 480),
                Text('Description Text 2'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 480),
                Text('Description Text 3'),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: <Widget>[
                SizedBox(height: 480),
                Text('Description Text 4'),
              ],
            ),
          ),
        ],
        onFinish: () {
          // Navigate to login screen or another screen after finishing onboarding
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
      ),
    );
  }
}
