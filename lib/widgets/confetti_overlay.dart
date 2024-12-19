import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ConfettiOverlay extends StatelessWidget {
  static void show(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => ConfettiOverlay(),
    );

    Future.delayed(const Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // Calculate animation size with a maximum limit
    final animationSize = screenSize.width * 0.8;
    final maxSize = 400.0; // Maximum size for larger screens
    final finalSize = animationSize > maxSize ? maxSize : animationSize;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          Positioned(
            top: screenSize.height * 0.3,
            // Center horizontally while respecting the final size
            left: (screenSize.width - finalSize) / 2,
            child: Lottie.asset(
              'assets/Confetti.json',
              width: finalSize,
              height: finalSize,
              fit: BoxFit.contain,
              repeat: false,
            ),
          ),
        ],
      ),
    );
  }
}