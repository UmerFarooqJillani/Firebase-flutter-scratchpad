import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  static Future<RemoteConfigService> init() async {
    final remoteConfig = FirebaseRemoteConfig.instance;

    // Optional: default values
    await remoteConfig.setDefaults(const {
      // setDefaults = ensures app has safe fallback if fetch fails.
      'welcome_message': 'Hello User!',
      'show_promo_banner': false,
    });

    // Fetch and activate remote values
    await remoteConfig.fetchAndActivate();    // fetchAndActivate() = downloads and applies latest values.
    return RemoteConfigService(remoteConfig);
  }

  String getString(String key) => _remoteConfig.getString(key);

  bool getBool(String key) => _remoteConfig.getBool(key);

  int getInt(String key) => _remoteConfig.getInt(key);

  double getDouble(String key) => _remoteConfig.getDouble(key);
}
