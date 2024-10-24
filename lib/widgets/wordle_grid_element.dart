import 'package:flutter/material.dart';

class WordleGridElement extends StatelessWidget {
  const WordleGridElement({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey,width: 2)

      ),
    );
  }
}