import 'dart:async';
import 'package:flutter/material.dart';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../screen/home_screen.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  Timer? _timer;

  @override
  void initState() {
    _timer = Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const HomeScreen()));
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: CachedNetworkImage(
              imageUrl:
                  'https://www.freeiconspng.com/uploads/new-get-video-frame-png-pictures-24.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.2,
            top: MediaQuery.of(context).size.height * 0.34,
            right: MediaQuery.of(context).size.width * 0.2,
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 26.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'We show weather for you',
                    curve: Curves.easeIn,
                    speed: const Duration(milliseconds: 80),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.6,
            bottom: MediaQuery.of(context).size.height * 0.3,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (_) => const HomeScreen()));
              },
              child: const Text("skip"),
            ),
          )
        ],
      ),
    );
  }
}
