import 'package:dio/dio.dart';
import 'site24x7_dio_client_adapter.dart';
import 'site24x7_dio_network_interceptor.dart';

extension Site24x7DioExtension on Dio {

  //Note: this should be added as a last configuration for dio object, else site24x7 configuration will be overriden with your configuration.
  enableSite24x7(){

    //interceptor to capture network exceptions
    interceptors.insert(0, Site24x7DioNetworkInterceptor());

    //intercept http requests
    httpClientAdapter = Site24x7DioClientAdapter(clientAdapter: httpClientAdapter);

  }
  
}