import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/analytics_crashlytics/application/provider.dart';

class AnalyticsDemoScreen extends ConsumerStatefulWidget {
  const AnalyticsDemoScreen({super.key});

  @override
  ConsumerState<AnalyticsDemoScreen> createState() =>
      _AnalyticsDemoScreenState();
}

class _AnalyticsDemoScreenState extends ConsumerState<AnalyticsDemoScreen> {
  @override
  Widget build(BuildContext context) {
    final analytics = ref.watch(analyticsProvider);
    final crashlytics = ref.watch(crashlyticsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Analytics Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await analytics.logEvent(
              'demo_button_pressed',
              {'button': 'demo'}, // Map<String, Object>
            );

            ScaffoldMessenger.of(
              // ignore: use_build_context_synchronously
              context,
            ).showSnackBar(const SnackBar(content: Text('Event logged!')));
            try {
              int result = 10 ~/ 0; // will throw
              debugPrint("$result");
            } catch (e, stack) {
              await crashlytics.logError(
                'Division by zero',
                error: e,
                stack: stack,
              );
            }
          },
          child: const Text('Press me'),
        ),
      ),
    );
  }
}
