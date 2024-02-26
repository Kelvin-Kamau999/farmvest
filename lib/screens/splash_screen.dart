import 'dart:async';

import 'package:cofarmer/common/primary_button.dart';
import 'package:cofarmer/screens/auth/auth_screen.dart';
import 'package:cofarmer/utils/constants.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 5), () {
      mounted
          ? Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SplashVideoScreen()))
          : null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Hero(
        tag: const Text('logo'),
        child: Center(
          child: Image.asset(
            'assets/images/logo.png',
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SplashVideoScreen extends StatefulWidget {
  const SplashVideoScreen({Key? key}) : super(key: key);

  @override
  _SplashVideoScreenState createState() => _SplashVideoScreenState();
}

class _SplashVideoScreenState extends State<SplashVideoScreen> {
  late VideoPlayerController _controller;
  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/splash.mp4');
    _controller.addListener(() {
      setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();

    Future.delayed(const Duration(seconds: 5), () {
      // Get.off(() => AuthScreen());
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                height: _controller.value.size.height,
                width: _controller.value.size.width,
                child: VideoPlayer(_controller),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                const SizedBox(
                  height: kToolbarHeight,
                ),
                Hero(
                  tag: const Text('logo'),
                  child: Center(
                    child: Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Spacer(),
                Text('UNLOCKING YOUR PORTFOLIO IN AGRICULTURE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.ibmPlexSans(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.2),
                            offset: const Offset(5.0, 5.0),
                          ),
                        ])),
                const SizedBox(height: 6),
                Text(
                  'Grow your portfolio through agri-investments',
                  style: TextStyle(color: Colors.white, shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(5.0, 5.0),
                    ),
                  ]),
                ),
                const Spacer(),
                PrimaryButton(
                  text: 'Login',
                  onTap: () {
                    Get.to(() => const AuthScreen());
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.white),
                    ),
                    TextButton(
                        onPressed: () {
                          Get.to(() => const AuthScreen(isSignUp: true));
                        },
                        child: const Text(
                          'Create an account',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
