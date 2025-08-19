import 'package:flutter/foundation.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'apm_mobileapm_flutter_plugin_method_channel.dart';

//Custom api's served to customer, will be through following interface
abstract class ApmMobileapmFlutterPluginPlatform extends PlatformInterface {
  /// Constructs a ApmMobileapmFlutterPluginPlatform.
  ApmMobileapmFlutterPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ApmMobileapmFlutterPluginPlatform _instance =
      MethodChannelApmMobileapmFlutterPlugin();

  /// The default instance of [ApmMobileapmFlutterPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelApmMobileapmFlutterPlugin].
  static ApmMobileapmFlutterPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ApmMobileapmFlutterPluginPlatform] when
  /// they register themselves.
  static set instance(ApmMobileapmFlutterPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<void> startMonitoring(String appKey, int uploadInterval) {
    throw UnimplementedError('startMonitoring() has not been implemented');
  }

  Future<void> startMonitoringWithEndPoint(String appKey, int uploadInterval, String endPoint) {
    throw UnimplementedError('startMonitoring() has not been implemented');
  }

  Future<void> enableErrorReporting() {
    throw UnimplementedError('enableErrorReporting() has not been implemented');
  }

  Future<void> startTransaction(String name) {
    throw UnimplementedError('startTransaction has not been implemented');
  }

  Future<void> stopTransaction(String name) {
    throw UnimplementedError('stopTransaction() has not been implemented');
  }

  Future<void> startComponent(String transactionName, String componentName) {
    throw UnimplementedError('startComponent has not been implemented');
  }

  Future<void> stopComponent(String transactionName, String componentName) {
    throw UnimplementedError('startComponent has not been implemented');
  }

  Future<void> crashApplication() {
    throw UnimplementedError('crashApplication has not been implemented');
  }

  Future<void> flush() {
    throw UnimplementedError('flush has not been implemented');
  }

  Future<void> setUserId(String id) {
    throw UnimplementedError('setUserId has not been implemented');
  }

  Future<void> addBreadcrumb(String name, String action) {
    throw UnimplementedError('addBreadcrumb has not been implemented');
  }

  Future<void> addScreen(String name, int loadTime, int startTime) {
    throw UnimplementedError('addScreen has not been implemented');
  }

  Future<void> captureException(dynamic throwable, dynamic stack, { String? reason, bool isHandled = true, String type = "caughtexception"}) {
    throw UnimplementedError('captureException has not been implemented');
  }

  Future<void> addHttpCall(String url, String requestMethod, int startTime,int loadTime, int statusCode) {
    throw UnimplementedError('addHttpCall has not been implemented');
  }

  Future<void> captureFlutterError(FlutterErrorDetails flutterErrorDetails, {bool fatal = false}){
    throw UnimplementedError('captureFlutterError has not been implemented');
  }

  Future<void> platformDispatcherErrorCallback(dynamic throwable, dynamic stack){
    throw UnimplementedError('platformDispatcherExceptionCallback');
  }

}
