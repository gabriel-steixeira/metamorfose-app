import 'package:http/http.dart';
import '../apm_mobileapm_flutter_plugin_platform_interface.dart';
import '../site24x7_string_extensions.dart';

class Site24x7HttpClient extends BaseClient {
  late Client _client;

  Site24x7HttpClient({Client? client}) {
    _client = client ?? Client();
  }

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    int? statusCode;
    final startTime = DateTime.now();
    try {
      final response = await _client.send(request);
      statusCode = response.statusCode;
      return response;
    } catch (exception, stack) {
      ApmMobileapmFlutterPluginPlatform.instance.captureException(exception, stack);
      rethrow;
    } finally {
      var requestDuration = DateTime.now().difference(startTime).inMilliseconds;
      var requestUrl = request.url.toString().s247SanitizedUrl();
      var requestMethod = request.method;
      ApmMobileapmFlutterPluginPlatform.instance.addHttpCall(requestUrl, requestMethod, startTime.millisecondsSinceEpoch, requestDuration, statusCode ?? 0);
    }
  }
}
