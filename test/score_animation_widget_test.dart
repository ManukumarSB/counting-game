import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:counting/score_card.dart';

void main() {
  testWidgets('score flare animation', (WidgetTester tester) async {
    var testKey = UniqueKey();
    await tester.pumpWidget(new MaterialApp(
      home: new Material(
        child: new ScoreCard(
          key: testKey,
        ),
      ),
    ));
    expect(find.byKey(testKey), findsOneWidget);
     await tester.pumpAndSettle(Duration(seconds: 1));
    await tester.tap(find.byType(GestureDetector).first);
  });
}
