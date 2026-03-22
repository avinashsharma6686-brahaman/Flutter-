# Snake Game

A Flutter Snake game built with pure Flutter widgets (CustomPainter, GestureDetector, Timer).

## Features
- Classic Snake gameplay: Eat red food to grow, avoid self-collision
- Wrap-around walls (toroidal grid)
- Swipe controls: Up/Down/Left/Right
- Score tracking
- Game over & restart
- Smooth animations and grid rendering
- 20x20 grid, 150ms update speed

## How to Play
1. Run `flutter run`
2. Swipe in 4 directions to control snake
3. Eat red food to increase score and length
4. Game ends on self-collision
5. Tap Restart to play again

## Getting Started
Standard Flutter project. Run:
```
flutter pub get
flutter run
```

## Customization
- Adjust `gridSize`, `cellSize`, Timer duration in `lib/main.dart`
- Colors/styles in SnakePainter

## Resources
- [Flutter CustomPainter](https://docs.flutter.dev/ui/advanced/custom-painter)
- Original: https://docs.flutter.dev/get-started/learn-flutter
