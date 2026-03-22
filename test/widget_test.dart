import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:my_app/main.dart';
import 'package:my_app/controllers/game_controller.dart';

void main() {
  testWidgets('Snake Game renders smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GameController()),
        ],
        child: const SnakeGameApp(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that title renders.
    expect(find.text('START GAME'), findsOneWidget);
  });
}

