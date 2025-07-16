import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/presentation/state/game_notifier.dart';
import 'package:minesweeper/presentation/widgets/cell_widget.dart';

class GameBoardWidget extends ConsumerWidget {
  const GameBoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameProvider);
    final board = gameState.board;
    final rows = board.length;
    final columns = board.isNotEmpty ? board[0].length : 0;
    final screenWidth = MediaQuery.of(context).size.width;
    final cellSize = (screenWidth - 20) / columns;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        rows,
        (x) => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            columns,
            (y) => SizedBox(
              width: cellSize,
              height: cellSize,
              child: CellWidget(board[x][y]),
            ),
          ),
        ),
      ),
    );
  }
}
