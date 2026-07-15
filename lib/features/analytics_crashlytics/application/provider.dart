import 'package:firebase_scratchpad/services/firebase/analytics_service.dart';
import 'package:firebase_scratchpad/services/firebase/crashlytics_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final analyticsProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService();
});

final crashlyticsProvider = Provider<CrashlyticsService>((ref) {
  final service = CrashlyticsService();
  service.enableCrashlytics();
  return service;
});