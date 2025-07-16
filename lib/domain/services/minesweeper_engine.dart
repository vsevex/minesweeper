import 'dart:math' as math;

import 'package:minesweeper/core/config/constants.dart';
import 'package:minesweeper/core/extensions/board.dart';
import 'package:minesweeper/core/utils/helpers.dart';
import 'package:minesweeper/domain/models/cell.dart';
import 'package:minesweeper/domain/models/config.dart';

class MinesweeperEngine {
  MinesweeperEngine({required this.rows, required this.columns});

  int rows;
  int columns;

  late List<List<Cell>> _board;
  late GameConfig config;

  List<List<Cell>> generateBoard(
    GameConfig config, {
    List<List<Cell>>? initialBoard,
  }) {
    // Set the game configuration
    this.config = config;
    // Initialize the empty board
    _board =
        initialBoard ??
        List.generate(
          rows,
          (x) => List.generate(columns, (y) => Cell(x: x, y: y)),
        );

    if (initialBoard?.isEmpty ?? true) {
      // Place mines on the board
      placeMines(
        mineCount: config.mineCount,
        safeX: config.safeX,
        safeY: config.safeY,
      );
    }

    // Calculate adjacent mine counts
    calculateAdjacentMines();

    return _board;
  }

  void placeMines({required int mineCount, int? safeX, int? safeY}) {
    final random = math.Random();
    int placed = 0;

    while (placed < mineCount) {
      final x = random.nextInt(rows);
      final y = random.nextInt(columns);

      // First click is always safe
      if (_board[x][y].isMine) {
        continue;
      }
      if (safeX != null && safeY != null) {
        final isSafeZone = (x - safeX).abs() <= 1 && (y - safeY).abs() <= 1;
        if (isSafeZone) {
          continue;
        }
      }

      _board[x][y].isMine = true;
      placed++;
    }
  }

  int calculateAdjacentMines() {
    int totalAdjacentMines = 0;

    for (int x = 0; x < rows; x++) {
      for (int y = 0; y < columns; y++) {
        if (_board[x][y].isMine) {
          continue;
        }

        int count = 0;

        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0) {
              continue;
            }

            final nx = x + dx;
            final ny = y + dy;

            if (nx >= 0 && nx < rows && ny >= 0 && ny < columns) {
              if (_board[nx][ny].isMine) {
                count++;
              }
            }
          }
        }

        _board[x][y].adjacentMines = count;
        totalAdjacentMines += count;
      }
    }

    return totalAdjacentMines;
  }

  void revealCell({required int x, required int y}) {
    if (!_isInBounds(x, y)) {
      return;
    }
    final cell = _board.getCell(x, y);

    if (cell.isRevealed || cell.isFlagged) {
      return;
    }

    _floodReveal(x, y);
  }

  void revealAllCells() {
    for (final row in _board) {
      for (final cell in row) {
        cell.isRevealed = true;
      }
    }
  }

  void _floodReveal(int startX, int startY) {
    final queue = <Cell>[_board.getCell(startX, startY)];

    while (queue.isNotEmpty) {
      final cell = queue.removeLast();
      if (cell.isRevealed || cell.isFlagged) {
        continue;
      }

      cell.isRevealed = true;

      if (cell.adjacentMines == 0) {
        for (int dx = -1; dx <= 1; dx++) {
          for (int dy = -1; dy <= 1; dy++) {
            if (dx == 0 && dy == 0) {
              continue;
            }

            final nx = cell.x + dx;
            final ny = cell.y + dy;

            if (_isInBounds(nx, ny)) {
              final neighbor = _board.getCell(nx, ny);
              if (!neighbor.isRevealed &&
                  !neighbor.isFlagged &&
                  !queue.contains(neighbor)) {
                queue.add(neighbor);
              }
            }
          }
        }
      }
    }
  }

  void flagCell(Cell cell) {
    if (!_isInBounds(cell.x, cell.y)) {
      return;
    }

    if (cell.isRevealed) {
      return;
    }

    cell.isFlagged = true;
  }

  void unflagCell(Cell cell) {
    if (!_isInBounds(cell.x, cell.y)) {
      return;
    }

    if (cell.isRevealed) {
      return;
    }

    cell.isFlagged = false;
  }

  void resetGame({int? rowSetter, int? colSetter}) {
    if (rowSetter != null) {
      rows = rowSetter;
    }
    if (colSetter != null) {
      columns = colSetter;
    }

    if (rows > 0 && columns > 0) {
      config.mineCount = getMineCount(defaultDifficulty, rows * columns);
    }

    _board = List.generate(
      rows,
      (x) => List.generate(columns, (y) => Cell(x: x, y: y)),
    );

    placeMines(
      mineCount: config.mineCount,
      safeX: config.safeX,
      safeY: config.safeY,
    );

    // Recalculate adjacent mines after resetting the board
    calculateAdjacentMines();
  }

  bool isGameOver() {
    for (final row in _board) {
      for (final cell in row) {
        if (cell.isMine && cell.isRevealed) {
          return true;
        }
      }
    }
    return false;
  }

  bool isGameWon() {
    for (final row in _board) {
      for (final cell in row) {
        if (cell.isMine && cell.isRevealed) {
          return false;
        }

        if (!cell.isMine && !cell.isRevealed) {
          return false;
        }
      }
    }

    return true;
  }

  // Check if the coordinates are within the bounds of the board
  bool _isInBounds(int x, int y) => x >= 0 && x < rows && y >= 0 && y < columns;

  // Getter for the board as a 2D list
  List<List<Cell>> get boardAs2DList => _board;

  // Method to get a specific cell
  Cell getCell(int x, int y) {
    if (!_isInBounds(x, y)) {
      throw Exception('Cell coordinates out of bounds');
    }
    return _board.getCell(x, y);
  }
}
