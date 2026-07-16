import 'package:firebase_scratchpad/services/firebase/remote_config_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final remoteConfigProvider =
    FutureProvider // FutureProvider ensures UI can handle loading, error, and data states.
    <RemoteConfigService>((ref) async {
      return await RemoteConfigService.init();
    });
