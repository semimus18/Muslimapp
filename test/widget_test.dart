import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:muslimapp/main.dart';

void main() {
  testWidgets('Muslim App loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MuslimApp());

    // Verify that the app title is displayed
    expect(find.text('Muslim App'), findsOneWidget);
    
    // Verify that the Islamic greeting is displayed
    expect(find.text('السلام عليكم ورحمة الله وبركاته'), findsOneWidget);
    
    // Verify that the bottom navigation has the expected tabs
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Prayer Times'), findsOneWidget);
    expect(find.text('Qibla'), findsOneWidget);
    expect(find.text('Dhikr'), findsOneWidget);
  });

  testWidgets('Navigation between tabs works', (WidgetTester tester) async {
    await tester.pumpWidget(const MuslimApp());
    
    // Wait for the app to load
    await tester.pumpAndSettle();
    
    // Tap on Prayer Times tab
    await tester.tap(find.text('Prayer Times'));
    await tester.pumpAndSettle();
    
    // Verify Prayer Times page is displayed
    expect(find.text('Prayer Times'), findsWidgets);
    
    // Tap on Qibla tab
    await tester.tap(find.text('Qibla'));
    await tester.pumpAndSettle();
    
    // Verify Qibla page is displayed
    expect(find.text('Qibla Direction'), findsOneWidget);
    
    // Tap on Dhikr tab
    await tester.tap(find.text('Dhikr'));
    await tester.pumpAndSettle();
    
    // Verify Dhikr page is displayed
    expect(find.text('Dhikr & Prayers'), findsOneWidget);
  });
}