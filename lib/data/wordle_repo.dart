import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

class WordLoadException implements Exception {
  final String message;
  const WordLoadException(this.message);
  @override
  String toString() => 'WordLoadException: $message';
}

// Cache for loaded words to avoid repeated asset loading
final Map<int, Map<String, List<String>>> _wordCache = {};

Future<Map<String, List<String>>> loadWords(int wordlength) async {
  // Return cached data if available
  if (_wordCache.containsKey(wordlength)) {
    return _wordCache[wordlength]!;
  }

  final String wordsPath = "assets/${wordlength}-letter-words.json";
  final String bankPath = "assets/${wordlength}-letter-words-bank.json";

  try {
    final data = await rootBundle.loadString(wordsPath);
    final vdata = await rootBundle.loadString(bankPath);

    final List<String> words = (jsonDecode(data) as List<dynamic>).cast<String>();
    final List<String> bank = (jsonDecode(vdata) as List<dynamic>).cast<String>();

    if (words.isEmpty || bank.isEmpty) {
      throw const WordLoadException('Word lists are empty for word length');
    }

    final result = {
      "data": words,
      "vdata": bank,
    };

    // Cache the result
    _wordCache[wordlength] = result;
    return result;
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

// Preload common word sizes for faster startup
Future<void> preloadWords() async {
  try {
    await Future.wait([
      loadWords(4),
      loadWords(5),
      loadWords(6),
    ]);
  } catch (e) {
    debugPrint('Failed to preload words: $e');
  }
}
