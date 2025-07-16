import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/core/config/enums.dart';
import 'package:minesweeper/presentation/state/game_notifier.dart';
import 'package:minesweeper/presentation/widgets/footer.dart';
import 'package:minesweeper/presentation/widgets/game_board_widget.dart';
import 'package:minesweeper/presentation/widgets/header.dart';
import 'package:minesweeper/presentation/widgets/overlay.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Pasha Minesweeper'), centerTitle: true),
      body: SizedBox.expand(
        child: Stack(
          children: <Widget>[
            const SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Header(),
                  SizedBox(height: 12),
                  GameBoardWidget(),
                  SizedBox(height: 12),
                  Footer(),
                ],
              ),
            ),
            if (gameState.status == GameStatus.won ||
                gameState.status == GameStatus.lost)
              buildEndGameOverlay(context, ref, gameState.status),
          ],
        ),
      ),
    );
  }
}
