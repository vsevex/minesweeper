import 'package:minesweeper/core/config/enums.dart';
import 'package:minesweeper/domain/models/cell.dart';

class GameState {
  GameState({
    required this.board,
    this.status = GameStatus.idle,
    this.flagCount = 0,
    this.elapsedTime = 0,
  });

  factory GameState.initial() => GameState(board: []);

  final List<List<Cell>> board;
  final GameStatus status;
  final int flagCount;
  final int elapsedTime;

  GameState copyWith({
    List<List<Cell>>? board,
    GameStatus? status,
    int? flagCount,
    int? elapsedTime,
  }) => GameState(
    board: board ?? this.board,
    status: status ?? this.status,
    flagCount: flagCount ?? this.flagCount,
    elapsedTime: elapsedTime ?? this.elapsedTime,
  );

  @override
  int get hashCode =>
      board.hashCode ^
      status.hashCode ^
      flagCount.hashCode ^
      elapsedTime.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameState &&
          runtimeType == other.runtimeType &&
          board == other.board &&
          status == other.status &&
          flagCount == other.flagCount &&
          elapsedTime == other.elapsedTime;

  @override
  String toString() =>
      'GameState(board: $board, status: $status, flagCount: $flagCount, elapsedTime: $elapsedTime)';
}
