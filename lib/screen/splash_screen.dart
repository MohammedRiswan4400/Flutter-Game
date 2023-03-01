import 'package:first_game/screen/game.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoMain();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 97, 190, 163),
      body: Center(
        child: Image(
          image: AssetImage(
            "assets/Screenshot 2023-02-03 145946.png",
          ),
        ),
      ),
    );
  }

  Future<void> gotoMain() async {
    await Future.delayed(
      const Duration(
        seconds: 3,
      ),
    );
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const GameScreen();
        },
      ),
    );
  }
}
