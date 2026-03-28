import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nagme/app.dart';
import 'package:nagme/main.dart';
import 'package:nagme/services/preferences_service.dart';

void main() {
  testWidgets('App başarıyla açılır', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3.0;
    addTearDown(tester.view.resetPhysicalSize);

    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          preferencesServiceProvider
              .overrideWithValue(PreferencesService(prefs)),
        ],
        child: const NagmeApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.mic_rounded), findsOneWidget);
  });
}
