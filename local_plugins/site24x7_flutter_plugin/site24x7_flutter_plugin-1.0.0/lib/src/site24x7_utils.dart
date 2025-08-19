import 'dart:convert';
import 'package:stack_trace/stack_trace.dart';
import 'site24x7_constants.dart';

class Site24x7Util {
  static String? _currentPageRoute;

  static bool stringValidator(String? val) {
    return val?.isNotEmpty ?? false;
  }

  static String? getCurrentPageRoute() {
    return _currentPageRoute;
  }

  static void setCurrentPageRoute(String? route) {
    if (route != null) {
      _currentPageRoute = route;
    }
  }

  static String _getStackTraceElementFromFrame(Frame frame) {
    final Map<String, dynamic> element = <String, dynamic>{
      s24FileName: frame.library,
      s24LineNo: frame.line ?? 0,
      s24ColumnNo: 0
    };
    final String member = frame.member ?? 'Unknown';
    final List<String> members = member.split('.');
    if (members.length > 1) {
      element[s24Function] = members.sublist(1).join('.');
      //element['class'] = members.first; //will be used when class name support is provided
    } else {
      element[s24Function] = member;
    }
    return json.encode(element);
  }

  static List<String> getStackTraceElements(StackTrace? stackTrace) {
    final Trace trace = Trace.parseVM(stackTrace.toString());
    final List<String> elements = <String>[];

    for (final Frame frame in trace.frames) {
      elements.add(_getStackTraceElementFromFrame(frame));
    }
    return elements.take(MAX_STACK_TRACE_LEN).toList();
  }
}
