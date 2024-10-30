import 'package:flutter/material.dart';

class WordleGridElement extends StatelessWidget {
  final int pos;
  final String letter;
  final bool attempted;
  final String correctword;
  
  const WordleGridElement({super.key,  required this.letter, required this.attempted, required this.correctword, required this.pos});

  Color? getBgColor(){
    if(!attempted) return null;
    if(!correctword.contains(letter))return  Colors.grey;
    if(correctword[pos]==letter) return Colors.green;
    return Colors.orangeAccent;
  }
  BoxBorder? getBorder(){
    if(!attempted) return Border.all(color: Colors.grey, width: 2);
    return Border.all(color: Colors.transparent,width: 2);
  }

  Color? getTextColor(){
    if(!attempted) return Colors.black;
    return Colors.white;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      width: 60,
      height: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: getBorder(),
        color: getBgColor(),
        borderRadius: BorderRadius.all(Radius.circular(4))
      
      ),
      child: Text(letter.toUpperCase() ,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold, color: getTextColor()),),
    );
  }
}