import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/presentation/state/game_notifier.dart';

part '_config_dialog.dart';

class Footer extends ConsumerWidget {
  const Footer({super.key});

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
            '🔴 Time: ${gameState.elapsedTime}',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
          InkWell(
            onTap: () => showDialog(
              context: context,
              builder: (_) => const GridConfigDialog(),
            ),
            borderRadius: BorderRadius.circular(8.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Icon(Icons.settings, size: fontSize),
                  const SizedBox(width: 4),
                  Text('Settings', style: TextStyle(fontSize: fontSize)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
