import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';



class WordleRow extends StatelessWidget {
 final int wordsize;
 final String word;
 const WordleRow({super.key, required this.wordsize, required this.word});

  @override
  Widget build(BuildContext context) {
    final List<WordleGridElement> boxes=List.empty(growable: true);
      for(int j=0;j<wordsize;j++){
        if(word.length>j){
          boxes.add(WordleGridElement(letter: word[j]));
        }
        else{
          boxes.add(WordleGridElement());
        }
      }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: boxes,
    );
  }
}
