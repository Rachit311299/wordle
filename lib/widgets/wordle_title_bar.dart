import 'package:flutter/material.dart';

class WordleTitleBar extends StatelessWidget {
  const WordleTitleBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("WORDLE",
          style:TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,

          ) ,),
        ],
      ),
    );
  }
}