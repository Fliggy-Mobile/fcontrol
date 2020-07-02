import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fcontrol/fcontrol.dart';

void main() {
  const MethodChannel channel = MethodChannel('fcontrol');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
//    expect(await FControl.platformVersion, '42');
  });
}
