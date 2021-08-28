import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('Testing App', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    test('Bookmark restaurant test', () async {
      final keys = [
        'Melting Pot',
        'Kafe Kita',
        'Bring Your Phone Cafe',
      ];

      for (var key in keys) {
        await driver.tap(find.byValueKey(key));
      }

      await driver.tap(find.byValueKey('bookmark_button_nav'));

      final listFinder = find.byType('ListView');
      final firstItem = find.text('Melting Pot');
      final secondItem = find.text('Kafe Kita');
      final thirdItem = find.text('Bring Your Phone Cafe');

      await driver.scrollUntilVisible(listFinder, firstItem, dyScroll: -300);
      await driver.scrollUntilVisible(listFinder, secondItem, dyScroll: -300);
      await driver.scrollUntilVisible(listFinder, thirdItem, dyScroll: -300);

      expect(await driver.getText(firstItem), 'Melting Pot');
      expect(await driver.getText(secondItem), 'Kafe Kita');
      expect(await driver.getText(thirdItem), 'Bring Your Phone Cafe');
    });
  });
}
