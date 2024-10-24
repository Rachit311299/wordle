import 'package:flutter/material.dart';

class WordleKeyElement extends StatelessWidget {
  final String letter;
  const WordleKeyElement({super.key, required this.letter});

  @override
  Widget build(BuildContext context) {

    Widget KeyCap;
    double width= 60;

    if(letter =="_") {
      KeyCap=const Icon(Icons.keyboard_return,size: 20,);
    }
    else if(letter=="+"){
      KeyCap=const Icon(Icons.backspace_outlined, size: 20,);
    }
    else{
      width=40;
      KeyCap= Text(letter, style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,

      ),);
    }

    return Container(
      width: width,
      height: 60,
      
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(5)),
        color: Color.fromARGB(44, 44, 44, 44)
      ),
      child: KeyCap,
    );
  } 
}