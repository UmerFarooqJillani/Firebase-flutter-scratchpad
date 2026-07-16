import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_scratchpad/features/remote_config/application/provider.dart';

class RemoteConfigDemoScreen extends ConsumerWidget {
  const RemoteConfigDemoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final remoteConfigAsync = ref.watch(remoteConfigProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Remote Config Demo')),
      body: remoteConfigAsync.when(
        data: (config) {
          final welcomeMessage = config.getString('welcome_message');
          final showBanner = config.getBool('show_promo_banner');

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(welcomeMessage, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 20),
              if (showBanner)
                Container(
                  color: Colors.amber,
                  padding: const EdgeInsets.all(16),
                  child: const Text(
                    'Promo Banner!',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }
}
