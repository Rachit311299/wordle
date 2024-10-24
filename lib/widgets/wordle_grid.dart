import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_row.dart';

const rows=6;



class WordleGrid extends StatelessWidget {
  const WordleGrid({super.key});

  @override
  Widget build(BuildContext context) {


    return Container(
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WordleRow(),
          WordleRow(),
          WordleRow(),
          WordleRow(),
          WordleRow(),
          WordleRow(),

        ],
      ),
    );
  }
}