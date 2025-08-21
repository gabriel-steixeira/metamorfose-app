//Below are the string extensions hooked onto natural string, so to avoid conflict between string extension methods provided by different packages and applications developers, 
//advisable to use prefix with unique name
extension S247StringExtension on String {

  String s247SanitizedUrl() {
    return replaceAll(RegExp('[^A-Za-z0-9:/?&=]'), '');
  }
}
