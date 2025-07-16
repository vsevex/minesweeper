# Pasha Minesweeper

## 🚀 Features

- ✅ Configurable grid size (rows, columns)
- ✅ Responsive layout
- ✅ Safe first-click logic
- ✅ Win/loss detection with overlay popups
- ✅ Touch feedback (haptics & ripple)
- ✅ Dynamic font sizing per cell
- ✅ Timer with live updates
- ✅ State management with **Riverpod**
- ✅ Fully testable `MinesweeperEngine` logic

## Architecture

- **UI is fully separated from business logic**
- **Game state is observable via Riverpod**
- **All game logic is unit-testable and side-effect-free**

## 🧪 Testing

Test coverage includes:

- ✅ `MinesweeperEngine` unit tests
  - Bomb placement
  - Adjacent mine count
  - Reveal logic + flood fill
  - Win/loss detection

Run tests:

```bash
flutter test
```

## ✅ Requirements

Flutter 3.10+
Dart 3.x
