import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:site24x7_flutter_plugin/src/apm_mobileapm_flutter_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelApmMobileapmFlutterPlugin platform = MethodChannelApmMobileapmFlutterPlugin();
  const MethodChannel channel = MethodChannel('apm_mobileapm_flutter_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
