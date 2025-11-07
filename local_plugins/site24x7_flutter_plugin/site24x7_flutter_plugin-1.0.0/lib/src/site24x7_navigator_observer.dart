import 'package:flutter/widgets.dart';
import 'site24x7_utils.dart';
import 'apm_mobileapm_flutter_plugin_platform_interface.dart';

class Site24x7NavigatorObserver extends RouteObserver<PageRoute<dynamic>> {
  
  Site24x7NavigatorObserver();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
		_setCurrentRoute(route);
    _addRouteBreadcrumb("didPush", previousRoute, route);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _setCurrentRoute(previousRoute);
    _addRouteBreadcrumb("didPop", previousRoute, route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _setCurrentRoute(newRoute);
    _addRouteBreadcrumb("didReplace", oldRoute, newRoute);
  }

  String? _getRouteName(Route<dynamic>? route) {
    return (route?.settings)?.name;
  }

  void _setCurrentRoute(Route<dynamic>? route) {
    final String? currentRoute = _getRouteName(route);
    if (currentRoute == null) return;
    Site24x7Util.setCurrentPageRoute(currentRoute);
  }

  void _addRouteBreadcrumb(String action, Route<dynamic>? from, Route<dynamic>? to) {
    String? prevRoute = _getRouteName(from);
    String? currRoute = _getRouteName(to);
    String? name = "";
    if (from != null) {
      name = "$prevRoute to $currRoute ";
    } else {
      name = "Navigating to $currRoute ";
    }
    ApmMobileapmFlutterPluginPlatform.instance.addBreadcrumb(name, action);
  }
}
