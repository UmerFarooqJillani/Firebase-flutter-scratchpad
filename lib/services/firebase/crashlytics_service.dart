import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsService {
  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  void enableCrashlytics() {
    // In production, catch all uncaught errors
    FlutterError.onError = _crashlytics.recordFlutterError;
  }

  Future<void> logError(
    String message, {
    dynamic error,
    StackTrace? stack,
  }) async {
    await _crashlytics.recordError(
      error ?? Exception(message),
      stack ?? StackTrace.current,
    );
  }

  // Force a test crash
  Future<void> testCrash() async {
    _crashlytics.crash();
  }
}
