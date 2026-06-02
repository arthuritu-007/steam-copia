import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:frontend/app.dart';

void main() {
  testWidgets('App renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const SteamCopiaApp());
    await tester.pumpAndSettle();
    expect(find.text('Steam Copia'), findsWidgets);
  });
}
