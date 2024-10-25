import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';



class WordleRow extends StatelessWidget {
 final int wordsize;
 const WordleRow({super.key, required this.wordsize});

  @override
  Widget build(BuildContext context) {
    final List<WordleGridElement> boxes=List.empty(growable: true);
      for(int j=0;j<wordsize;j++){
        boxes.add(const WordleGridElement());
      }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: boxes,
    );
  }
}
