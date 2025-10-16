import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wordle/providers/history_provider.dart';
import 'package:wordle/theme/theme_data.dart';

class HistoryTab extends ConsumerWidget {
  const HistoryTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(historyProvider);
    if (history.isEmpty) {
      return const Center(
        child: Text('No games yet'),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      itemCount: history.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final item = history[index];
        final theme = Theme.of(context);
        final onSurface = theme.colorScheme.onSurface;
        final bg = theme.colorScheme.surface;
        final wonColor = Colors.green.shade700;
        final lostColor = Colors.red.shade700;

        return Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: onSurface.withOpacity(0.1)),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 8,
                height: 44,
                decoration: BoxDecoration(
                  color: item.won ? wonColor : lostColor,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          item.won ? 'Won' : 'Lost',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: onSurface,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${item.attemptsUsed}/${item.attemptsAllowed} attempts',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'Word: ${item.correctWord.toUpperCase()} (${item.wordSize})',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        Text(
                          _formatDate(item.playedAt),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurface.withOpacity(0.6),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 6),
                    _MiniGrid(
                      guesses: item.guesses,
                      correctWord: item.correctWord,
                      wordSize: item.wordSize,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime dt) {
    final d = dt;
    final two = (int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year}  ${two(d.hour)}:${two(d.minute)}';
  }
}

class _MiniGrid extends StatelessWidget {
  final List<String> guesses;
  final String correctWord;
  final int wordSize;
  const _MiniGrid({
    required this.guesses,
    required this.correctWord,
    required this.wordSize,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final defaultGrey = AppTheme.gameColors.getDefaultGrey(brightness);

    List<Widget> rows = [];
    for (final guess in guesses) {
      final colors = _computeRowColors(
        guess,
        correctWord,
        defaultGrey,
        AppTheme.gameColors.correctColor,
        AppTheme.gameColors.misplacedColor,
      );
      rows.add(Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(wordSize, (i) {
          final color = i < colors.length ? colors[i] : defaultGrey;
          return Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: rows,
    );
  }

  List<Color> _computeRowColors(
    String word,
    String correct,
    Color defaultGrey,
    Color correctColor,
    Color misplacedColor,
  ) {
    final int n = word.length;
    final List<Color> colors = List<Color>.filled(n, defaultGrey);
    final Map<String, int> remaining = {};

    for (final ch in correct.split('')) {
      remaining[ch] = (remaining[ch] ?? 0) + 1;
    }

    for (int i = 0; i < n; i++) {
      if (i < correct.length && word[i] == correct[i]) {
        colors[i] = correctColor;
        remaining[word[i]] = (remaining[word[i]] ?? 0) - 1;
      }
    }

    for (int i = 0; i < n; i++) {
      if (colors[i] == defaultGrey) {
        final ch = word[i];
        if ((remaining[ch] ?? 0) > 0) {
          colors[i] = misplacedColor;
          remaining[ch] = remaining[ch]! - 1;
        }
      }
    }

    return colors;
  }
}


