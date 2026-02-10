import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final RemoteConfigService _instance = RemoteConfigService._internal();
  factory RemoteConfigService() => _instance;
  RemoteConfigService._internal();

  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  String? _debugOverrideColor;

  Future<void> initialize() async {
    try {
      // Fallback if user is offline
      await _remoteConfig.setDefaults({'primary_color': '0xFF9C27B0'});

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

  Future<bool> fetchAndActivate() async {
    bool updated = await _remoteConfig.fetchAndActivate();
    print("Remote Config manually refreshed: $updated");
    return updated;
  }

  void setDebugColor(String? color) {
    _debugOverrideColor = color;
  }

  String get primaryColorString {
    if (_debugOverrideColor != null) {
      return _debugOverrideColor!;
    }
    return _remoteConfig.getString('primary_color');
  }
}
