import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../controllers/game_controller.dart';
import '../models/enums.dart';
import '../widgets/game_board.dart';
import 'home_screen.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SafeArea(
        child: Consumer<GameController>(
          builder: (context, controller, child) {
            return Focus(
              autofocus: true,
              onKeyEvent: (node, event) {
                if (event is KeyDownEvent) {
                  if (event.logicalKey == LogicalKeyboardKey.arrowUp || event.logicalKey == LogicalKeyboardKey.keyW) {
                    controller.handleSwipe(Direction.up);
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowDown || event.logicalKey == LogicalKeyboardKey.keyS) {
                    controller.handleSwipe(Direction.down);
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
                    controller.handleSwipe(Direction.left);
                    return KeyEventResult.handled;
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
                    controller.handleSwipe(Direction.right);
                    return KeyEventResult.handled;
                  }
                }
                return KeyEventResult.ignored;
              },
              child: Stack(
                children: [
                  Column(
                    children: [
                      _buildHeader(context, controller),
                      Expanded(
                        child: GestureDetector(
                          onVerticalDragUpdate: (details) {
                            if (details.delta.dy > 0) {
                              controller.handleSwipe(Direction.down);
                            } else if (details.delta.dy < 0) {
                              controller.handleSwipe(Direction.up);
                            }
                          },
                          onHorizontalDragUpdate: (details) {
                            if (details.delta.dx > 0) {
                              controller.handleSwipe(Direction.right);
                            } else if (details.delta.dx < 0) {
                              controller.handleSwipe(Direction.left);
                            }
                          },
                          child: Container(
                            color: Colors.transparent, // Ensures entire area detects swipe
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: GameBoard(),
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildDPad(controller),
                      const SizedBox(height: 20),
                    ],
                  ),
                  if (controller.gameState == GameState.paused)
                    _buildPauseOverlay(context, controller),
                  if (controller.gameState == GameState.gameOver)
                    _buildGameOverOverlay(context, controller),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDPad(GameController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Column(
        children: [
          _dirButton(Icons.arrow_upward, () => controller.handleSwipe(Direction.up)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _dirButton(Icons.arrow_back, () => controller.handleSwipe(Direction.left)),
              const SizedBox(width: 60),
              _dirButton(Icons.arrow_forward, () => controller.handleSwipe(Direction.right)),
            ],
          ),
          _dirButton(Icons.arrow_downward, () => controller.handleSwipe(Direction.down)),
        ],
      ),
    );
  }

  Widget _dirButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.greenAccent.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        iconSize: 48,
        color: Colors.greenAccent,
        icon: Icon(icon),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Score: ${controller.score}',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.pause, color: Colors.white, size: 36),
            onPressed: () {
              controller.pauseGame();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPauseOverlay(BuildContext context, GameController controller) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'PAUSED',
              style: TextStyle(
                fontSize: 48,
                color: Colors.white,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 40),
            _OverlayButton(
              text: 'RESUME',
              color: Colors.greenAccent,
              onPressed: () => controller.resumeGame(),
            ),
            const SizedBox(height: 20),
            _OverlayButton(
              text: 'RESTART',
              color: Colors.blueAccent,
              onPressed: () => controller.startGame(),
            ),
            const SizedBox(height: 20),
            _OverlayButton(
              text: 'HOME',
              color: Colors.redAccent,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameOverOverlay(BuildContext context, GameController controller) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'GAME OVER',
              style: TextStyle(
                fontSize: 48,
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Score: ${controller.score}',
              style: const TextStyle(fontSize: 28, color: Colors.white),
            ),
            Text(
              'High Score: ${controller.highScore}',
              style: const TextStyle(fontSize: 20, color: Colors.white70),
            ),
            const SizedBox(height: 40),
            _OverlayButton(
              text: 'PLAY AGAIN',
              color: Colors.greenAccent,
              onPressed: () => controller.startGame(),
            ),
            const SizedBox(height: 20),
            _OverlayButton(
              text: 'HOME',
              color: Colors.grey,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OverlayButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _OverlayButton({
    required this.text,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
