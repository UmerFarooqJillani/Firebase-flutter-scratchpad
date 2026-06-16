import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:firebase_scratchpad/features/firestore_learning/realtime_streams/application/realtime_user_provider.dart';

class RealtimeUserScreen extends ConsumerWidget {
  final String uid;

  const RealtimeUserScreen({super.key, required this.uid});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userStreamProvider(uid));

    return userAsync.when(
      loading: () => const CircularProgressIndicator(),

      error: (e, _) => Text(e.toString()),

      data: (user) {
        return Text("Name: ${user?.name ?? ''}  (Streaming Fetch");
      },
    );
  }
}
