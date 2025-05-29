import 'package:flutter/foundation.dart';

class ValidationState {
  final bool isValid;
  final String? errorMessage;

  const ValidationState({
    required this.isValid,
    this.errorMessage,
  });
} 