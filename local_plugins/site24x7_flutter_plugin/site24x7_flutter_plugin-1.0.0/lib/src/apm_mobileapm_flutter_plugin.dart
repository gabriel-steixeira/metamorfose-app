import 'package:flutter/foundation.dart';

import 'apm_mobileapm_flutter_plugin_platform_interface.dart';

//This class is used to serve the custom api's to customer.
class ApmMobileapmFlutterPlugin {

  static final ApmMobileapmFlutterPlugin _instance = ApmMobileapmFlutterPlugin();
  //singleton instance will be used, rather than creating multiple objects of this class in cx applicaiton.
  static ApmMobileapmFlutterPlugin get instance => _instance;

  Future<void> startMonitoring(String appKey, int uploadInterval) {
    return ApmMobileapmFlutterPluginPlatform.instance.startMonitoring(appKey, uploadInterval);
  }

  Future<void> startMonitoringWithEndPoint(String appKey, int uploadInterval, String endPoint) {
    return ApmMobileapmFlutterPluginPlatform.instance.startMonitoringWithEndPoint(appKey, uploadInterval, endPoint);
  }

  Future<void> startTransaction(String name) {
    return ApmMobileapmFlutterPluginPlatform.instance.startTransaction(name);
  }

  Future<void> stopTransaction(String name) {
    return ApmMobileapmFlutterPluginPlatform.instance.stopTransaction(name);
  }

  Future<void> startComponent(String transactionName, String componentName) {
    return ApmMobileapmFlutterPluginPlatform.instance
        .startComponent(transactionName, componentName);
  }

  Future<void> stopComponent(String transactionName, String componentName) {
    return ApmMobileapmFlutterPluginPlatform.instance
        .stopComponent(transactionName, componentName);
  }

  Future<void> enableErrorReporting() {
    return ApmMobileapmFlutterPluginPlatform.instance.enableErrorReporting();
  }

  Future<void> crashApplication() {
    return ApmMobileapmFlutterPluginPlatform.instance.crashApplication();
  }

  Future<void> flush() {
    return ApmMobileapmFlutterPluginPlatform.instance.flush();
  }

  Future<void> setUserId(String userId) {
    return ApmMobileapmFlutterPluginPlatform.instance.setUserId(userId);
  }

  Future<void> addBreadcrumb(String name, String action) {
    return ApmMobileapmFlutterPluginPlatform.instance.addBreadcrumb(name, action);
  }

  Future<void> addScreen(String name, int loadTime, int startTime) {
    return ApmMobileapmFlutterPluginPlatform.instance.addScreen(name, loadTime, startTime);
  }

  Future<void> captureException(dynamic throwable, dynamic stack, { String? reason, bool isHandled = true, String type = "caughtexception"}) {
    return ApmMobileapmFlutterPluginPlatform.instance.captureException(throwable, stack);
  }

  Future<void> addHttpCall(String url, String requestMethod, int startTime, int loadTime, int statusCode){
    return ApmMobileapmFlutterPluginPlatform.instance.addHttpCall(url, requestMethod, startTime, loadTime, statusCode);
  }

  Future<void> captureFlutterError(FlutterErrorDetails flutterErrorDetails, {bool fatal = false}){
    return ApmMobileapmFlutterPluginPlatform.instance.captureFlutterError(flutterErrorDetails, fatal: fatal);
  }

  Future<void> platformDispatcherErrorCallback(dynamic throwable, dynamic stack) async {
    return ApmMobileapmFlutterPluginPlatform.instance.platformDispatcherErrorCallback(throwable, stack);
  }

}
