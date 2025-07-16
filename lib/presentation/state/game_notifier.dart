import 'dart:async' as async;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:minesweeper/core/config/constants.dart';
import 'package:minesweeper/core/config/enums.dart';
import 'package:minesweeper/core/utils/helpers.dart';
import 'package:minesweeper/domain/models/config.dart';
import 'package:minesweeper/domain/services/minesweeper_engine.dart';
import 'package:minesweeper/presentation/state/game_state.dart';

final gameProvider = StateNotifierProvider<_GameNotifier, GameState>(
  (ref) => _GameNotifier(),
);

class _GameNotifier extends StateNotifier<GameState> {
  _GameNotifier() : super(GameState.initial()) {
    const cellCount = defaultRows * defaultColumns;
    final mineCount = getMineCount(defaultDifficulty, cellCount);
    _engine = MinesweeperEngine(rows: defaultRows, columns: defaultColumns);
    _engine.generateBoard(GameConfig(mineCount: mineCount));
    state = GameState(board: _engine.boardAs2DList, flagCount: mineCount);
  }

  late MinesweeperEngine _engine;
  async.Timer? _timer;

  double calculateCellFontSize({
    required double screenWidth,
    double minSize = 8,
    double maxSize = 24,
    int columns = defaultColumns,
  }) {
    final cellSize = screenWidth / columns;

    final fontSize = cellSize * .5;

    return fontSize.clamp(minSize, maxSize);
  }

  void _startTimer() {
    _timer = async.Timer.periodic(
      const Duration(seconds: 1),
      (_) => state = state.copyWith(elapsedTime: state.elapsedTime + 1),
    );
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void resetGame({int? rows, int? columns}) {
    _engine.resetGame(rowSetter: rows, colSetter: columns);
    _stopTimer();
    state = GameState(
      board: _engine.boardAs2DList,
      flagCount: _engine.config.mineCount,
    );
  }

  void reveal(int x, int y) {
    // Safe zone tap
    if (state.status == GameStatus.idle) {
      final flagged = _engine.boardAs2DList
          .expand((row) => row)
          .where((cell) => cell.isFlagged)
          .toList();
      _engine.generateBoard(
        GameConfig(
          safeX: x,
          safeY: y,
          mineCount: getMineCount(
            defaultDifficulty,
            _engine.rows * _engine.columns,
          ),
        ),
      );
      state = state.copyWith(status: GameStatus.playing);
      _startTimer();
      for (final cell in flagged) {
        toggleFlag(cell.x, cell.y);
      }
    }

    _engine.revealCell(x: x, y: y);

    if (_engine.isGameOver()) {
      _engine.revealAllCells();
      _stopTimer();
      state = state.copyWith(
        board: _engine.boardAs2DList,
        status: GameStatus.lost,
      );
    } else if (_engine.isGameWon()) {
      state = state.copyWith(
        board: _engine.boardAs2DList,
        status: GameStatus.won,
      );
      _stopTimer();
    } else {
      _updateState();
    }
  }

  void toggleFlag(int x, int y) {
    final cell = _engine.getCell(x, y);

    if (cell.isRevealed) {
      return;
    }

    if (cell.isFlagged) {
      _engine.unflagCell(cell);
    } else {
      if (state.flagCount == 0) {
        return;
      }
      _engine.flagCell(cell);
    }

    _updateState();
  }

  void _updateState() {
    final flagged = _engine.boardAs2DList
        .expand((row) => row)
        .where((cell) => cell.isFlagged)
        .length;

    state = state.copyWith(
      board: _engine.boardAs2DList,
      flagCount: _engine.config.mineCount - flagged,
    );
  }
}
