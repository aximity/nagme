import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nagme/app.dart';
import 'package:nagme/providers/settings_provider.dart';

void main() {
  testWidgets('Uygulama başlatma smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
        ],
        child: const NagmeApp(),
      ),
    );

    expect(find.byType(NagmeApp), findsOneWidget);
  });
}
