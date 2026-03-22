import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_model.dart';

class PauseScreen extends StatelessWidget {
  const PauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gameModel = Provider.of<GameModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF2E7D32),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Paused title
            const Icon(
              Icons.pause_circle_filled,
              size: 120,
              color: Colors.white,
            ),
            const SizedBox(height: 32),
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Score: ${gameModel.score}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 64),
            
            // Resume Button
            GestureDetector(
              onTap: () => gameModel.resumeGame(),
              child: Container(
                width: 240,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.lightGreen, Colors.green],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'RESUME',
                      style: TextStyle(
                        fontSize: 24,
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
            
            // Restart Button
            GestureDetector(
              onTap: () => gameModel.restartGame(),
              child: Container(
                width: 240,
                height: 70,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.orange, Colors.red],
                  ),
                  borderRadius: BorderRadius.circular(35),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.replay, color: Colors.white, size: 28),
                    const SizedBox(width: 12),
                    const Text(
                      'RESTART',
                      style: TextStyle(
                        fontSize: 24,
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
            
            // Home Button
            TextButton.icon(
              onPressed: () {
                gameModel.gameOver();
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              icon: const Icon(Icons.home, color: Colors.white70, size: 24),
              label: const Text(
                'HOME',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

