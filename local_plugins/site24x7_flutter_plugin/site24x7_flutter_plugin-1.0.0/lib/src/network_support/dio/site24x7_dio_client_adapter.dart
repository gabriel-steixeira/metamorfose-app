import 'dart:typed_data';
import 'package:dio/dio.dart';
import '../../apm_mobileapm_flutter_plugin_platform_interface.dart';
import '../../site24x7_string_extensions.dart';

class Site24x7DioClientAdapter implements HttpClientAdapter {
  late HttpClientAdapter _clientAdapter;

  Site24x7DioClientAdapter({required HttpClientAdapter clientAdapter}) {
    _clientAdapter = clientAdapter;
  }

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<Uint8List>? requestStream, Future<void>? cancelFuture) async {
    int? statusCode;
    ResponseBody? responseBody;
    final startTime = DateTime.now();
    try {
      responseBody = await _clientAdapter.fetch(options, requestStream, cancelFuture);
      statusCode = responseBody.statusCode;
      return responseBody;
    } catch (exception, stack) {
      ApmMobileapmFlutterPluginPlatform.instance.captureException(exception, stack);
      rethrow;
    } finally {
      var requestDuration = DateTime.now().difference(startTime).inMilliseconds;
      var requestUrl = options.uri.toString().s247SanitizedUrl();
      var requestMethod = options.method;
      ApmMobileapmFlutterPluginPlatform.instance.addHttpCall(requestUrl, requestMethod, startTime.millisecondsSinceEpoch, requestDuration, statusCode ?? 0);
    }
  }

  @override
  void close({bool force = false}) {
    _clientAdapter.close(force: force);
  }
}
