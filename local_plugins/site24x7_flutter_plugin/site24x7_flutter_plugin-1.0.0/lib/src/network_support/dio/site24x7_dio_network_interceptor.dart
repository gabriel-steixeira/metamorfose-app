import '../../apm_mobileapm_flutter_plugin_platform_interface.dart';
import 'package:dio/dio.dart';

class Site24x7DioNetworkInterceptor extends Interceptor {

  Site24x7DioNetworkInterceptor();

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    ApmMobileapmFlutterPluginPlatform.instance.captureException(err.error, err.stackTrace, isHandled: false);
    super.onError(err, handler);
  }
}
