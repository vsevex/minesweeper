import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/core/utils/helpers.dart';
import 'package:minesweeper/domain/models/cell.dart';
import 'package:minesweeper/presentation/state/game_notifier.dart';

class CellWidget extends ConsumerWidget {
  const CellWidget(this.cell, {super.key});

  final Cell cell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String text = '';
    Color backgroundColor;

    final notifier = ref.watch(gameProvider.notifier);

    if (cell.isRevealed) {
      backgroundColor = Colors.grey.shade300;
      if (cell.isMine) {
        text = '💣';
      } else if (cell.adjacentMines > 0) {
        text = cell.adjacentMines.toString();
      }
    } else {
      backgroundColor = Colors.grey.shade500;
      if (cell.isFlagged) {
        text = '🚩';
      }
    }

    return InkWell(
      onTap: cell.isRevealed
          ? null
          : () {
              HapticFeedback.lightImpact();
              notifier.reveal(cell.x, cell.y);
            },
      onLongPress: cell.isRevealed
          ? null
          : () {
              HapticFeedback.heavyImpact();
              notifier.toggleFlag(cell.x, cell.y);
            },
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: notifier.calculateCellFontSize(
              screenWidth: MediaQuery.of(context).size.width,
            ),
            fontWeight: FontWeight.bold,
            color: isNumeric(text)
                ? getAdjacentMinesColor(int.parse(text))
                : Colors.black,
          ),
        ),
      ),
    );
  }
}
