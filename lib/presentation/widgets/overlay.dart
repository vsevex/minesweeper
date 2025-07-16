import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/core/config/enums.dart';
import 'package:minesweeper/presentation/state/game_notifier.dart';

Widget buildEndGameOverlay(
  BuildContext context,
  WidgetRef ref,
  GameStatus status,
) {
  final isWin = status == GameStatus.won;

  return Positioned.fill(
    child: Container(
      color: Colors.black.withValues(alpha: .6),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isWin ? '🎉 You Won!' : '😔 Game Over!',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => ref.read(gameProvider.notifier).resetGame(),
            child: const Text('Play Again'),
          ),
        ],
      ),
    ),
  );
}
