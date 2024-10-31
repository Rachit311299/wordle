import 'dart:convert';

import 'package:flutter/services.dart';

Future<Map<String, List<String>>> loadWords(int wordlength) async {
  final data = await rootBundle.loadString("assets/${wordlength}-letter-words.json");
  final vdata = await rootBundle.loadString("assets/${wordlength}-letter-words-bank.json");

  return {
    "data": (jsonDecode(data) as List<dynamic>).cast<String>(),
    "vdata": (jsonDecode(vdata) as List<dynamic>).cast<String>(),
  };
}
