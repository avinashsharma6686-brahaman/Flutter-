import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../models/enums.dart';
import '../services/storage_service.dart';

class GameController extends ChangeNotifier {
  static const int gridSize = 20; // 20x20 grid
  
  List<Point<int>> snake = [];
  Point<int>? ball;
  
  Direction currentDirection = Direction.right;
  Direction? nextDirection; // to prevent reversing direction in a single tick
  
  GameState gameState = GameState.idle;
  
  int score = 0;
  int highScore = 0;
  
  Timer? _timer;
  final Random _random = Random();
  
  GameController() {
    _loadHighScore();
  }
  
  Future<void> _loadHighScore() async {
    highScore = await StorageService.getHighScore();
    notifyListeners();
  }
  
  void startGame() {
    // Reset state
    snake = [
      const Point(10, 10),
      const Point(9, 10),
      const Point(8, 10),
    ];
    currentDirection = Direction.right;
    nextDirection = null;
    score = 0;
    gameState = GameState.playing;
    _spawnBall();
    
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 150), _tick);
    notifyListeners();
  }
  
  void pauseGame() {
    if (gameState == GameState.playing) {
      gameState = GameState.paused;
      _timer?.cancel();
      notifyListeners();
    }
  }
  
  void resumeGame() {
    if (gameState == GameState.paused) {
      gameState = GameState.playing;
      _timer = Timer.periodic(const Duration(milliseconds: 150), _tick);
      notifyListeners();
    }
  }
  
  void handleSwipe(Direction newDir) {
    if (gameState != GameState.playing) return;
    
    // Prevent 180 degree turns
    bool isReverse(Direction d1, Direction d2) {
      if (d1 == Direction.up && d2 == Direction.down) return true;
      if (d1 == Direction.down && d2 == Direction.up) return true;
      if (d1 == Direction.left && d2 == Direction.right) return true;
      if (d1 == Direction.right && d2 == Direction.left) return true;
      return false;
    }
    
    if (!isReverse(currentDirection, newDir)) {
      nextDirection = newDir;
    }
  }
  
  void _tick(Timer timer) {
    if (gameState != GameState.playing) return;
    
    if (nextDirection != null) {
      currentDirection = nextDirection!;
      nextDirection = null;
    }
    
    Point<int> head = snake.first;
    Point<int> newHead;
    
    switch (currentDirection) {
      case Direction.up:
        newHead = Point(head.x, head.y - 1);
        break;
      case Direction.down:
        newHead = Point(head.x, head.y + 1);
        break;
      case Direction.left:
        newHead = Point(head.x - 1, head.y);
        break;
      case Direction.right:
        newHead = Point(head.x + 1, head.y);
        break;
    }
    
    // Check collisions
    if (_checkCollision(newHead)) {
      _gameOver();
      return;
    }
    
    snake.insert(0, newHead); // Add new head
    
    // Check if eaten ball
    if (newHead == ball) {
      score += 10;
      _spawnBall();
      // snake grows by not removing tail
    } else {
      snake.removeLast(); // Remove tail
    }
    
    notifyListeners();
  }
  
  bool _checkCollision(Point<int> head) {
    // Wall collision (can be configurable, but let's make it fatal for now)
    if (head.x < 0 || head.x >= gridSize || head.y < 0 || head.y >= gridSize) {
      return true;
    }
    // Self collision
    if (snake.contains(head)) {
      return true;
    }
    return false;
  }
  
  void _spawnBall() {
    Point<int> newPos;
    do {
      newPos = Point(_random.nextInt(gridSize), _random.nextInt(gridSize));
    } while (snake.contains(newPos));
    ball = newPos;
  }
  
  Future<void> _gameOver() async {
    gameState = GameState.gameOver;
    _timer?.cancel();
    if (score > highScore) {
      highScore = score;
      await StorageService.saveHighScore(highScore);
    }
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
