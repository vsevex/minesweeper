import 'package:minesweeper/domain/models/cell.dart';

extension Board on List<List<Cell>> {
  Cell getCell(int x, int y) => this[x][y];
  void setCell(Cell cell) => this[cell.x][cell.y] = cell;
}
