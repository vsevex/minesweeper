import 'package:flutter_test/flutter_test.dart';

import 'package:minesweeper/domain/models/cell.dart';
import 'package:minesweeper/domain/models/config.dart';
import 'package:minesweeper/domain/services/minesweeper_engine.dart';

void main() {
  group('MinesweeperEngine Tests', () {
    late MinesweeperEngine engine;

    setUp(() {
      engine = MinesweeperEngine(rows: 5, columns: 5)
        ..generateBoard(GameConfig(safeX: 1, safeY: 1));
    });

    test('Initial board dimensions', () {
      expect(engine.boardAs2DList.length, 5);
      expect(engine.boardAs2DList[0].length, 5);
    });

    test('Correct number of mines placed', () {
      final mineCount = engine.boardAs2DList
          .expand((row) => row)
          .where((cell) => cell.isMine)
          .length;

      expect(mineCount, 3);
    });

    test('Flagging and unflagging works correctly', () {
      final board = engine.boardAs2DList;
      final cell = board[0][0];
      expect(cell.isFlagged, isFalse);

      engine.flagCell(cell);
      expect(cell.isFlagged, isTrue);

      engine.unflagCell(cell);
      expect(cell.isFlagged, isFalse);
    });

    test('Reveal a non-mine cell does not end game', () {
      final safeCell = engine.boardAs2DList
          .expand((row) => row)
          .firstWhere((cell) => !cell.isMine);

      engine.revealCell(x: safeCell.x, y: safeCell.y);

      expect(engine.isGameOver(), isFalse);
      expect(safeCell.isRevealed, isTrue);
    });

    test('Reveal a mine ends the game', () {
      final mineCell = engine.boardAs2DList
          .expand((row) => row)
          .firstWhere((cell) => cell.isMine);

      engine.revealCell(x: mineCell.x, y: mineCell.y);

      expect(engine.isGameOver(), isTrue);
      expect(mineCell.isRevealed, isTrue);
    });

    test('Flood reveal on 0-adjacent cell', () {
      final config = GameConfig(safeX: 3, safeY: 3, mineCount: 0);
      final engine = MinesweeperEngine(rows: 3, columns: 3)
        ..generateBoard(config)
        ..revealCell(x: 1, y: 1);

      final revealedCells = engine.boardAs2DList
          .expand((row) => row)
          .where((cell) => cell.isRevealed)
          .length;

      expect(revealedCells, 9);
    });

    test('Winning the game', () {
      final engine = MinesweeperEngine(rows: 5, columns: 5)
        ..generateBoard(
          GameConfig(safeX: 1, safeY: 1, mineCount: 1),
          initialBoard: List.generate(
            5,
            (x) => List.generate(
              5,
              (y) => Cell(x: x, y: y, isMine: (x == 0 && y == 0)),
            ),
          ),
        );

      for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
          if (!engine.boardAs2DList[x][y].isMine) {
            engine.boardAs2DList[x][y].adjacentMines = engine
                .calculateAdjacentMines();
          }
        }
      }

      for (int x = 0; x < 5; x++) {
        for (int y = 0; y < 5; y++) {
          if (!(x == 0 && y == 0)) {
            engine.revealCell(x: x, y: y);
          }
        }
      }

      expect(engine.isGameOver(), isFalse);
      expect(engine.isGameWon(), isTrue);
    });

    test('Reset game clears board and places new mines on the board', () {
      engine.resetGame();

      final mineCount = engine.boardAs2DList
          .expand((row) => row)
          .where((cell) => cell.isMine)
          .length;

      expect(mineCount, 3);

      final unrevealed = engine.boardAs2DList
          .expand((row) => row)
          .where((cell) => !cell.isRevealed)
          .length;

      expect(unrevealed, 25);
    });
  });
}
