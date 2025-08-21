import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'site24x7_constants.dart';
import 'apm_mobileapm_flutter_plugin_platform_interface.dart';
import 'site24x7_utils.dart';

/// An implementation of [ApmMobileapmFlutterPluginPlatform] that uses method channels.
class MethodChannelApmMobileapmFlutterPlugin
    extends ApmMobileapmFlutterPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('apm_mobileapm_flutter_plugin');

  bool _doesSdkInitialized = false;

  @override
  Future<void> startMonitoring(String appKey, int uploadInterval) async {
    if (appKey.isEmpty) return;
    try {
      _doesSdkInitialized = true;
      return await methodChannel.invokeMethod('startMonitoring', <String, dynamic>{
        "appKey": appKey,
        "uploadInterval": uploadInterval
      });
    } on PlatformException catch (exception) {
      throw ArgumentError(
          'Unable to start site24x7 monitoring : ${exception.message}');
    }
  }

  @override
  Future<void> startMonitoringWithEndPoint(String appKey, int uploadInterval, String endPoint) async {
    if (appKey.isEmpty) return;
    try {
      _doesSdkInitialized = true;
      return await methodChannel.invokeMethod('startMonitoring', <String, dynamic>{
        "appKey": appKey,
        "uploadInterval": uploadInterval,
        "endPoint": endPoint
      });
    } on PlatformException catch (exception) {
      throw ArgumentError(
          'Unable to start site24x7 monitoring : ${exception.message}');
    }
  }

  @override
  Future<void> enableErrorReporting() async {
    try {
      if (!_doesSdkInitialized) return;
      return await methodChannel.invokeMethod('trackNativeExceptions');
    } on PlatformException catch (exception) {
      throw ArgumentError(
          'Unable to start site24x7 enableErrorReporting: ${exception.message}');
    }
  }

  @override
  Future<void> startTransaction(String name) async {
    if (!_doesSdkInitialized || name.isEmpty) return;
    try {
      return await methodChannel
          .invokeMethod('startTransaction', <String, String>{"name": name});
    } on PlatformException catch (exception) {
      throw ArgumentError(
          'Unable to start site24x7 transaction: ${exception.message}');
    }
  }

  @override
  Future<void> stopTransaction(String name) async {
    if (!_doesSdkInitialized || name.isEmpty) return;
    try {
      return await methodChannel
          .invokeMethod('stopTransaction', <String, String>{"name": name});
    } on PlatformException catch (exception) {
      throw ArgumentError(
          'Unable to stop site24x7 transaction: ${exception.message}');
    }
  }

  @override
  Future<void> startComponent(String transactionName, String componentName) async {
    if (!_doesSdkInitialized ||
        transactionName.isEmpty ||
        componentName.isEmpty) return;
    try {
      return await methodChannel.invokeMethod(
          'startComponent', <String, String>{
        "transactionName": transactionName,
        "componentName": componentName
      });
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to start component: ${exception.message}');
    }
  }

  @override
  Future<void> stopComponent(String transactionName, String componentName) async {
    if (!_doesSdkInitialized ||
        transactionName.isEmpty ||
        componentName.isEmpty) return;
    try {
      return await methodChannel.invokeMethod('stopComponent', <String, String>{
        "transactionName": transactionName,
        "componentName": componentName
      });
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to start component: ${exception.message}');
    }
  }

//Note: try-catch shouldn't be used, because it prevents application from crashing
  @override
  Future<void> crashApplication() async {
    return await methodChannel.invokeMethod("crashNative");
  }

  @override
  Future<void> flush() async {
    try {
      return await methodChannel.invokeMethod("flush");
    } on PlatformException catch (exception) {
      throw ArgumentError(
          'Unable to flush the transactions: ${exception.message}');
    }
  }

  @override
  Future<void> setUserId(String id) async {
    try {
      if (!_doesSdkInitialized || id.isEmpty) return;
      return await methodChannel
          .invokeMethod("setUserId", <String, String>{"userId": id});
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to set user id: ${exception.message}');
    }
  }

  @override
  Future<void> addBreadcrumb(String name, String action) async {
    try {
      if (!_doesSdkInitialized || name.isEmpty || action.isEmpty) return;
      return await methodChannel.invokeMethod(
          "addBreadcrumb", <String, String>{"name": name, "action": action});
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to add breadcrumb: $exception.message');
    }
  }

  @override
  Future<void> addScreen(String name, int loadTime, int startTime) async {
    try {
      if (!_doesSdkInitialized || name.isEmpty) return;
      return await methodChannel.invokeMethod("addScreen", <String, dynamic>{
        "name": name,
        "loadTime": loadTime,
        "startTime": startTime
      });
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to add screen: $exception.message');
    }
  }

  @override
  Future<void> addHttpCall(String url, String requestMethod, int startTime, int loadTime, int statusCode) async {
    if (!_doesSdkInitialized || url.isEmpty || requestMethod.isEmpty) return;
    try {
      String? currentRoute = Site24x7Util.getCurrentPageRoute();
      return await methodChannel.invokeMethod('addHttpCall', <String, dynamic>{
        "url": url,
        "requestMethod": requestMethod,
        "startTime": startTime,
        "loadTime": loadTime,
        "statusCode": statusCode,
        "currentRoute": currentRoute ?? 'Unknown'
      });
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to add http call: $exception.message');
    }
  }

  //Note: Can be used for capturing async exceptions (PlatformDispatcher.instance.onError) and caught exceptions (ex: using catch block)
  @override
  Future<void> captureException(dynamic throwable, dynamic stack, { String? reason, bool isHandled = true, String type = "caughtexception"}) async {
    try {
      if (!_doesSdkInitialized) return;
      
      final StackTrace? stackTrace = (stack == null || stack.toString().isEmpty) ? StackTrace.current : stack;
      final List<String> stackTraceElements = Site24x7Util.getStackTraceElements(stackTrace);
      String? file;
      String? function;
      if(stackTraceElements.isNotEmpty){
        Map<String, dynamic> firstStackFrame = json.decode(stackTraceElements[0]);
        file = firstStackFrame[s24FileName];
        function = firstStackFrame[s24Function]?.replaceAll(RegExp(r'<fn>'), "Unknown");
      }
      return await methodChannel.invokeMethod('captureException', <String, dynamic>{
        //"throwable": throwable, 
        "msg": throwable.toString(),
        "startTime" : DateTime.now().millisecondsSinceEpoch,
        "function" : function ?? 'Unknown',
        "file" : file ?? 'Unknown',
        "stack": stackTraceElements.toString(),
        "currentRoute": Site24x7Util.getCurrentPageRoute() ?? "-",
        "type" : type,
        "isHandled": isHandled 
      });
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to capture exception: $exception.message');
    }
  }

  //Note: Callback used to capture async exceptions (PlatformDispatcher.instance.onError)
  @override
  Future<void> platformDispatcherErrorCallback(dynamic throwable, dynamic stack) async {
    return await captureException(throwable, stack, isHandled: true, type: "uncaughtexception");
  }

  //Note: Used to capture non-async exceptions (FlutterError.onError)
  @override
  Future<void> captureFlutterError(FlutterErrorDetails flutterErrorDetails, {bool fatal = false}) async {
    try {
      FlutterError.presentError(flutterErrorDetails);
      return await captureException(flutterErrorDetails.exception, flutterErrorDetails.stack, isHandled: true, reason: flutterErrorDetails.exception.runtimeType.toString(), type: "uncaughtexception");
    } on PlatformException catch (exception) {
      throw ArgumentError('Unable to capture flutter error: $exception.message');
    }
  }
}
