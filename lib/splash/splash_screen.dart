import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key,required this.nextRoute}) : super(key: key);
final String nextRoute;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void goToStart(){
    Navigator.pushReplacementNamed(context,widget.nextRoute);
  }
  Timer? timer;
  @override
  void initState() {
    timer= Timer(const Duration(seconds: 1), goToStart);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor:Colors.white,
      body: Center(
        child: Image.asset('${(kDebugMode && kIsWeb)?"":"assets/"}images/loading.gif'),
      ),
    );
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}