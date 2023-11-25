import 'package:flutter/material.dart';

import '../main.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    mq=MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: mq.width*.3,
            top: mq.height*.2,
            width: mq.width*.4,
              child: Image.asset('assets/images/logo.png'),),
          Text('Made in Russia')
        ],
      ),
    );
  }
}
