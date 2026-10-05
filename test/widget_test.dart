import 'package:flutter_test/flutter_test.dart';
import 'package:sparzee/main.dart';

void main() {
  testWidgets('Sparzee app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SparzeeApp());
    expect(find.byType(SparzeeApp), findsOneWidget);
    await tester.pumpAndSettle(const Duration(seconds: 3));
  });
}
