import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import 'dart:ui' as ui;

enum GameState { idle, playing, paused, gameOver }
enum Direction { up, down, left, right }

class GameModel extends ChangeNotifier {
  // Game settings
  final int gridSize = 20;
  double cellSize = 15.0;
  Duration tickDuration = const Duration(milliseconds: 150);

  // Game state
  List<Offset> snake = [const Offset(10, 10)];
  Direction direction = Direction.right;
  Offset food = const Offset.zero();
  int score = 0;
  int highScore = 0;
  GameState gameState = GameState.idle;
  bool isPaused = false;
  late Timer gameTimer;

  GameModel() {
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    final prefs = await SharedPreferences.getInstance();
    highScore = prefs.getInt('high_score') ?? 0;
    notifyListeners();
  }

  Future<void> _saveHighScore() async {
    if (score > highScore) {
      highScore = score;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('high_score', highScore);
    }
  }

  void startGame() {
    snake = [const Offset(10, 10)];
    direction = Direction.right;
    score = 0;
    gameState = GameState.playing;
    isPaused = false;
    _generateFood();
    _startTimer();
    notifyListeners();
  }

  void pauseGame() {
    isPaused = true;
    gameState = GameState.paused;
    notifyListeners();
  }

  void resumeGame() {
    isPaused = false;
    gameState = GameState.playing;
    notifyListeners();
  }

  void gameOver() async {
    gameTimer.cancel();
    gameState = GameState.gameOver;
    await _saveHighScore();
    notifyListeners();
  }

  void restartGame() {
    startGame();
  }

  void _startTimer() {
    gameTimer = Timer.periodic(tickDuration, (timer) {
      if (gameState != GameState.playing || isPaused) return;
      update();
    });
  }

  void update() {
    Offset head = snake.first;
    Offset newHead;

    switch (direction) {
      case Direction.up:
        newHead = Offset(head.dx, head.dy - 1);
        break;
      case Direction.down:
        newHead = Offset(head.dx, head.dy + 1);
        break;
      case Direction.left:
        newHead = Offset(head.dx - 1, head.dy);
        break;
      case Direction.right:
        newHead = Offset(head.dx + 1, head.dy);
        break;
    }

    // Wrap around (toroidal)
    newHead = Offset(
      newHead.dx.clamp(0, gridSize - 1),
      newHead.dy.clamp(0, gridSize - 1),
    );

    // Self collision
    if (snake.contains(newHead)) {
      gameOver();
      return;
    }

    snake.insert(0, newHead);

    // Food collision
    if ((newHead.dx - food.dx).abs() < 0.8 && (newHead.dy - food.dy).abs() < 0.8) {
      score += 10;
      _generateFood();
    } else {
      snake.removeLast();
    }

    notifyListeners();
  }

  void changeDirection(Direction newDir) {
    // Prevent reverse
    switch (newDir) {
      case Direction.up:
        if (direction != Direction.down) direction = newDir;
        break;
      case Direction.down:
        if (direction != Direction.up) direction = newDir;
        break;
      case Direction.left:
        if (direction != Direction.right) direction = newDir;
        break;
      case Direction.right:
        if (direction != Direction.left) direction = newDir;
        break;
    }
  }

  void _generateFood() {
    final random = Random();
    do {
      food = Offset(
        random.nextDouble() * (gridSize - 1),
        random.nextDouble() * (gridSize - 1),
      );
    } while (snake.any((segment) => (segment.dx - food.dx).abs() < 0.8 && (segment.dy - food.dy).abs() < 0.8));
  }

  @override
  void dispose() {
    gameTimer.cancel();
    super.dispose();
  }
}

class SnakePainter extends CustomPainter {
  final GameModel game;

  SnakePainter(this.game);

  @override
  void paint(Canvas canvas, Size size) {
    final cellSize = game.cellSize;
    final gridSize = game.gridSize;

    // Grid background
    final gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    // Food (ball)
    final foodRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        game.food.dx * cellSize,
        game.food.dy * cellSize,
        cellSize * 0.8,
        cellSize * 0.8,
      ),
      Radius.circular(cellSize * 0.4),
    );
    final foodGradient = ui.Gradient.radial(
      Offset(game.food.dx * cellSize + cellSize * 0.4, game.food.dy * cellSize + cellSize * 0.4),
      cellSize * 0.4,
      [Colors.orange, Colors.red],
    );
    final foodPaint = Paint()
      ..shader = foodGradient
      ..style = PaintingStyle.fill;
    canvas.drawRRect(foodRect, foodPaint);

    // Snake
    for (int i = 0; i < game.snake.length; i++) {
      final segmentRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(
          game.snake[i].dx * cellSize,
          game.snake[i].dy * cellSize,
          cellSize * 0.9,
          cellSize * 0.9,
        ),
        Radius.circular(cellSize * 0.3),
      );
      
      Paint segmentPaint;
      if (i == 0) {
        // Head
        segmentPaint = Paint()
          ..shader = ui.Gradient.linear(
            Offset(game.snake[i].dx * cellSize, game.snake[i].dy * cellSize),
            Offset(game.snake[i].dx * cellSize + cellSize, game.snake[i].dy * cellSize + cellSize),
            [const Color(0xFF006400), Colors.green],
          )
          ..style = PaintingStyle.fill;
      } else {
        // Body
        segmentPaint = Paint()
          ..color = Colors.green.withOpacity(0.8 - i * 0.01)
          ..style = PaintingStyle.fill;
      }
      canvas.drawRRect(segmentRect, segmentPaint);
    }

    // Grid lines
    final linePaint = Paint()
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;
    for (int i = 0; i <= gridSize; i++) {
      canvas.drawLine(
        Offset(i * cellSize, 0),
        Offset(i * cellSize, size.height),
        linePaint,
      );
      canvas.drawLine(
        Offset(0, i * cellSize),
        Offset(size.width, i * cellSize),
        linePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
