import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:vpn_basic_project/screens/home_screen.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 1500),(){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      Get.off(()=>HomeScreen());
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>HomeScreen()));
    });
  }
  
  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: mq.width * .3,
            top: mq.height * .2,
            width: mq.width * .4,
            child: Image.asset('assets/images/logo.png'),
          ),
          Positioned(
              bottom: mq.height * .15,
              width: mq.width,
              child: Text(
                'Made in Russia',
                textAlign: TextAlign.center,
                style: TextStyle(color:Colors.black54,letterSpacing: 1),
              ))
        ],
      ),
    );
  }
}
