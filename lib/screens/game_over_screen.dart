import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_model.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameModel = Provider.of<GameModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1B5E20),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Game Over icon
            const Icon(
              Icons.close,
              size: 100,
              color: Colors.red,
            ),
            const SizedBox(height: 24),
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 16),
            
            // Score display
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ScoreCard('SCORE', gameModel.score, Colors.orange),
                      _ScoreCard('BEST', gameModel.highScore, Colors.yellow),
                    ],
                  ),
                ],
              ),
            ),
            
            // Buttons
            const SizedBox(height: 48),
            GestureDetector(
              onTap: () => gameModel.restartGame(),
              child: Container(
                width: 260,
                height: 75,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(38),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.replay, size: 30, color: Colors.white),
                    const SizedBox(width: 16),
                    const Text(
                      'PLAY AGAIN',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            GestureDetector(
              onTap: () {
                gameModel.gameState = GameState.idle;
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Container(
                width: 260,
                height: 75,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.lightGreen, Colors.green],
                  ),
                  borderRadius: BorderRadius.circular(38),
                  border: Border.all(color: Colors.white.withOpacity(0.4)),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home, size: 30, color: Colors.white),
                    const SizedBox(width: 16),
                    const Text(
                      'HOME',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _ScoreCard(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            '$value',
            style: TextStyle(
              fontSize: 28,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

