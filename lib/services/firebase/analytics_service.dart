import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView(String screenName) async {
    await _analytics.logScreenView(
      // track which screen the user visits.
      screenName: screenName,
    );
  }

  Future<void> logEvent(
    String eventName,
    Map<String, Object>? parameters,
  ) async {
    await _analytics.logEvent(
      // track custom events (button clicks, form submission, etc.)
      name: eventName,
      parameters: parameters,
    );
  }
}
