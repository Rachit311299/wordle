import 'package:flutter/material.dart';
import 'package:wordle/widgets/wordle_grid_element.dart';



class WordleRow extends StatelessWidget {
 final int wordsize;
 final String word;
 final String correctWord;
 final bool attempted;

 const WordleRow({super.key, required this.wordsize, required this.word, required this.attempted, required this.correctWord});

  @override
  Widget build(BuildContext context) {
    final List<WordleGridElement> boxes=List.empty(growable: true);
      for(int j=0;j<wordsize;j++){

        var letter="";
        if(word.length>j){
          letter=word[j];
        }
        boxes.add(WordleGridElement(
          pos: j,
          letter: letter,
          attempted: attempted,
          correctword: correctWord,
      ));
        
      }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: boxes,
    );
  }
}
