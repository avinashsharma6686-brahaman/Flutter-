import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';
import '../controllers/game_controller.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({super.key});

  @override
  Widget build(BuildContext context) {
    final gameController = context.watch<GameController>();
    
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(color: Colors.greenAccent, width: 4),
          borderRadius: BorderRadius.circular(8),
        ),
        child: CustomPaint(
          painter: BoardPainter(
            snake: gameController.snake,
            ball: gameController.ball,
            gridSize: GameController.gridSize,
          ),
        ),
      ),
    );
  }
}

class BoardPainter extends CustomPainter {
  final List<Point<int>> snake;
  final Point<int>? ball;
  final int gridSize;

  BoardPainter({
    required this.snake,
    required this.ball,
    required this.gridSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width == 0 || size.height == 0) return;
    
    final double cellWidth = size.width / gridSize;
    final double cellHeight = size.height / gridSize;
    
    // Draw ball
    if (ball != null) {
      final ballPaint = Paint()..color = Colors.redAccent;
      canvas.drawCircle(
        Offset(
          ball!.x * cellWidth + cellWidth / 2,
          ball!.y * cellHeight + cellHeight / 2,
        ),
        cellWidth / 2.5,
        ballPaint,
      );
    }
    
    // Draw snake
    final headPaint = Paint()..color = Colors.greenAccent;
    final bodyPaint = Paint()..color = Colors.green;
    
    for (int i = 0; i < snake.length; i++) {
      final point = snake[i];
      final rect = Rect.fromLTWH(
        point.x * cellWidth + 1,
        point.y * cellHeight + 1,
        cellWidth - 2,
        cellHeight - 2,
      );
      
      if (i == 0) {
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(4)), headPaint);
      } else {
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(2)), bodyPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant BoardPainter oldDelegate) {
    return true; // We want to repaint every tick
  }
}
