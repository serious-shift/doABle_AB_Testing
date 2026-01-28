import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> initialize() async {
    try {
      // Fallback if user is offline
      await _remoteConfig.setDefaults({
        'show_new_feature': false,
        'promo_text': 'Willkommen!',
      });

      // Fetch and activate remote config
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(seconds: 0),
          // minimumFetchInterval: kDebugMode ? const Duration(seconds: 0) : const Duration(hours: 12),
        ),
      );

      // Fetch and activate the remote config values
      await _remoteConfig.fetchAndActivate();
      print('Remote Config initialized successfully.');
    } catch (e) {
      print('Error initializing Remote Config: $e');
    }
  }

  bool get showNewFeature => _remoteConfig.getBool('show_new_feature');
  String get promoText => _remoteConfig.getString('promo_text');
}
