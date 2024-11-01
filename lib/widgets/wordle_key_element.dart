import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/game_state_provider.dart';

class WordleKeyElement extends ConsumerWidget {
  final String letter;
  const WordleKeyElement({super.key, required this.letter});

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    Widget KeyCap;
    double width= 55;

    if(letter =="_") {
      KeyCap=const Icon(Icons.keyboard_return,size: 18,);
    }
    else if(letter=="+"){
      KeyCap=const Icon(Icons.backspace_outlined, size: 18,);
    }
    else{
      width=35;
      KeyCap= Text(letter.toUpperCase(), style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,

      ),);
    }
    return InkWell(
      onTap: () {
        ref.read(gameStateProvider.notifier).updateCurrentAttempt(context,letter);
      },
      child: Container(
          width: width,
          height: 50,
          alignment: Alignment.center,
          margin: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Color.fromARGB(44, 44, 44, 44)),
          child: KeyCap),
    );
 
  } 
}