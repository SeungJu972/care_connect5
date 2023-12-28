import 'package:flutter/material.dart';
import 'dart:async';
import 'package:care_connect/screen/login/home_screen.dart';

class LogoScreen extends StatefulWidget {
  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class _LogoScreenState extends State<LogoScreen> {
  @override
  void initState() {
    super.initState();
    // 5초 후에 HomeScreen으로 이동
    Timer(Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: MediaQuery.of(context).size.width, // 화면 넓이에 맞게 이미지 확장
          fit: BoxFit.fitWidth, // 이미지가 넓이에 맞게 확장될 수 있도록 설정
        ),
      ),
    );
  }
}
