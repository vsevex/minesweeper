import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/presentation/state/game_notifier.dart';

class Header extends ConsumerWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final gameStateNotifier = ref.read(gameProvider.notifier);
    final fontSize = gameStateNotifier.calculateCellFontSize(
      screenWidth: MediaQuery.of(context).size.width,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            '💣 Remaining: ${gameState.flagCount}',
            style: TextStyle(fontSize: fontSize),
          ),
          InkWell(
            onTap: gameStateNotifier.resetGame,
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.restart_alt_rounded, size: fontSize),
                  const SizedBox(width: 4),
                  Text('Reset', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
