import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bus_me/models/notification_model.dart';

void main() {
  testWidgets('Test _sendAlert', (WidgetTester tester) async {
    final notificationModel = NotificationModel();

    NotificationModel().addNotifType(NotifType.ALERT);

    final testWidget = MaterialApp(
      home: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () async {
            await NotificationModel().sendNotification("Test", context);
          },
          child: Text('Show Alert'),
        ),
      ),
    );

    await tester.pumpWidget(testWidget);

    await tester.tap(find.text('Show Alert'));
    await tester.pumpAndSettle();

    // Verify that the alert dialog is displayed
    expect(find.byType(AlertDialog), findsOneWidget);
  });
}