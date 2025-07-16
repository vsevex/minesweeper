import 'package:flutter/material.dart';

import 'package:minesweeper/core/config/enums.dart';

int getMineCount(GameDifficulty difficulty, int cellCount) {
  switch (difficulty) {
    case GameDifficulty.easy:
      return cellCount ~/ 10;
    case GameDifficulty.medium:
      return cellCount ~/ 8;
    case GameDifficulty.hard:
      return cellCount ~/ 6;
  }
}

Color getAdjacentMinesColor(int adjacentMines) {
  switch (adjacentMines) {
    case 1:
      return Colors.blue;
    case 2:
      return Colors.green;
    case 3:
      return Colors.red;
    case 4:
      return Colors.purple;
    case 5:
      return Colors.brown;
    case 6:
      return Colors.cyan;
    case 7:
      return Colors.black;
    case 8:
      return Colors.grey;
    default:
      return Colors.transparent;
  }
}

bool isNumeric(String s) => int.tryParse(s) != null;
