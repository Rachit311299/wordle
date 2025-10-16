import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class WordLoadException implements Exception {
  final String message;
  WordLoadException(this.message);
  @override
  String toString() => 'WordLoadException: $message';
}

Future<Map<String, List<String>>> loadWords(int wordlength) async {
  final String wordsPath = "assets/${wordlength}-letter-words.json";
  final String bankPath = "assets/${wordlength}-letter-words-bank.json";

  try {
    final data = await rootBundle.loadString(wordsPath);
    final vdata = await rootBundle.loadString(bankPath);

    final List<String> words = (jsonDecode(data) as List<dynamic>).cast<String>();
    final List<String> bank = (jsonDecode(vdata) as List<dynamic>).cast<String>();

    if (words.isEmpty || bank.isEmpty) {
      throw WordLoadException('Word lists are empty for word length $wordlength');
    }

    return {
      "data": words,
      "vdata": bank,
    };
  } on FlutterError catch (e) {
    // Asset not found or similar
    throw WordLoadException('Failed to load assets for length $wordlength: ${e.message}');
  } on FormatException catch (e) {
    // JSON malformed
    throw WordLoadException('Invalid JSON in assets for length $wordlength: ${e.message}');
  } catch (e) {
    throw WordLoadException('Unexpected error loading words: $e');
  }
}
