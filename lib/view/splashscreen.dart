import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_screen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    splash();
  }

  splash() {
    Timer(const Duration(seconds: 3), () {
      Get.off(() => const Home());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: const Center(
        child: Text(
          "CURD",
          style: TextStyle(
              fontSize: 22,
              color: Colors.white,
              decoration: TextDecoration.none),
        ),
      ),
    );
  }
}
