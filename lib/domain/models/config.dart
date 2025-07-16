class GameConfig {
  GameConfig({this.safeX = 0, this.safeY = 0, this.mineCount = 3});

  final int safeX;
  final int safeY;
  int mineCount;

  @override
  int get hashCode => safeX.hashCode ^ safeY.hashCode & mineCount.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameConfig &&
          runtimeType == other.runtimeType &&
          safeX == other.safeX &&
          safeY == other.safeY &&
          mineCount == other.mineCount;

  @override
  String toString() =>
      'GameConfig(safeX: $safeX, safeY: $safeY, mineCount: $mineCount)';
}
