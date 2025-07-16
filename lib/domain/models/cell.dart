class Cell {
  Cell({
    required this.x,
    required this.y,
    this.adjacentMines = 0,
    this.isMine = false,
    this.isFlagged = false,
    this.isRevealed = false,
  });

  final int x;
  final int y;
  int adjacentMines;
  bool isRevealed;
  bool isMine;
  bool isFlagged;

  Cell copyWith({
    int? x,
    int? y,
    int? adjacentMines,
    bool? isRevealed,
    bool? isMine,
    bool? isFlagged,
  }) => Cell(
    x: x ?? this.x,
    y: y ?? this.y,
    adjacentMines: adjacentMines ?? this.adjacentMines,
    isRevealed: isRevealed ?? this.isRevealed,
    isMine: isMine ?? this.isMine,
    isFlagged: isFlagged ?? this.isFlagged,
  );

  @override
  int get hashCode =>
      Object.hash(isRevealed, isMine, isFlagged, x, y, adjacentMines);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    } else {
      return other is Cell &&
          other.isRevealed == isRevealed &&
          other.isMine == isMine &&
          other.isFlagged == isFlagged &&
          other.x == x &&
          other.y == y &&
          other.adjacentMines == adjacentMines;
    }
  }

  @override
  String toString() =>
      'Cell(isRevealed: $isRevealed, isMine: $isMine, isFlagged: $isFlagged, x: $x, y: $y, adjacentMines: $adjacentMines)';
}
