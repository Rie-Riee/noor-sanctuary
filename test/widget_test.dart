import 'package:flutter_test/flutter_test.dart';
import 'package:islamic_lifestyle_app/main.dart';

void main() {
  testWidgets('App loads successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const NoorSanctuaryApp());
    expect(find.text('NOOR SANCTUARY'), findsOneWidget);
  });
}
