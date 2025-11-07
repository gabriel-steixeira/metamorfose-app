import 'package:flutter/src/foundation/assertions.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:site24x7_flutter_plugin/src/apm_mobileapm_flutter_plugin_method_channel.dart';
import 'package:site24x7_flutter_plugin/src/apm_mobileapm_flutter_plugin_platform_interface.dart';

class MockApmMobileapmFlutterPluginPlatform
    with MockPlatformInterfaceMixin
    implements ApmMobileapmFlutterPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<void> addBreadcrumb(String name, String action) {
    // TODO: implement addBreadcrumb
    throw UnimplementedError();
  }

  @override
  Future<void> addHttpCall(String url, String requestMethod, int startTime, int loadTime, int statusCode) {
    // TODO: implement addHttpCall
    throw UnimplementedError();
  }

  @override
  Future<void> addScreen(String name, int loadTime, int startTime) {
    // TODO: implement addScreen
    throw UnimplementedError();
  }

  @override
  Future<void> captureFlutterError(FlutterErrorDetails flutterErrorDetails, {bool fatal = false}) {
    // TODO: implement captureFlutterError
    throw UnimplementedError();
  }

  @override
  Future<void> crashApplication() {
    // TODO: implement crashApplication
    throw UnimplementedError();
  }

  @override
  Future<void> enableErrorReporting() {
    // TODO: implement enableErrorReporting
    throw UnimplementedError();
  }

  @override
  Future<void> flush() {
    // TODO: implement flush
    throw UnimplementedError();
  }

  @override
  Future<void> setUserId(String id) {
    // TODO: implement setUserId
    throw UnimplementedError();
  }

  @override
  Future<void> startComponent(String transactionName, String componentName) {
    // TODO: implement startComponent
    throw UnimplementedError();
  }

  @override
  Future<void> startMonitoring(String appKey, int uploadInterval) {
    // TODO: implement startMonitoring
    throw UnimplementedError();
  }

  @override
  Future<void> startMonitoringWithEndPoint(String appKey, int uploadInterval, String endPoint) {
    // TODO: implement startMonitoringWithEndPoint
    throw UnimplementedError();
  }

  @override
  Future<void> startTransaction(String name) {
    // TODO: implement startTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> stopComponent(String transactionName, String componentName) {
    // TODO: implement stopComponent
    throw UnimplementedError();
  }

  @override
  Future<void> stopTransaction(String name) {
    // TODO: implement stopTransaction
    throw UnimplementedError();
  }
  
  @override
  Future<void> captureException(throwable, stack, {String? reason, bool isHandled = true, String type = "caughtexception"}) {
    // TODO: implement captureException
    throw UnimplementedError();
  }
  
  @override
  Future<void> platformDispatcherErrorCallback(throwable, stack) {
    // TODO: implement platformDispatcherErrorCallback
    throw UnimplementedError();
  }
}

void main() {
  final ApmMobileapmFlutterPluginPlatform initialPlatform = ApmMobileapmFlutterPluginPlatform.instance;

  test('$MethodChannelApmMobileapmFlutterPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelApmMobileapmFlutterPlugin>());
  });
}
