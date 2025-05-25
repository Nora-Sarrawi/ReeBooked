import 'package:flutter_test/flutter_test.dart';
import 'package:rebooked_app/app.dart'; // import your ReBooked widget

void main() {
  testWidgets('Start screen shows app name', (tester) async {
    await tester.pumpWidget(const ReBooked());

    // look for the text “ReBooked” on the start screen
    expect(find.text('ReBooked'), findsOneWidget);
  });
}
