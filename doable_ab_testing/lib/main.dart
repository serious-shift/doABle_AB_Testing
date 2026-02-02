import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/core/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await RemoteConfigService().initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _installationId = 'Fetching...';

  @override
  void initState() {
    super.initState();
    _getFirebaseInstallationId();
  }

  Future<void> _getFirebaseInstallationId() async {
    try {
      final String? installationId = await FirebaseInstallations.instance
          .getId();
      setState(() {
        _installationId = installationId ?? 'Unknown';
      });
      print('Firebase Installation ID: $_installationId');
    } catch (e) {
      setState(() {
        _installationId = 'error: $e';
      });
      print('error fetching Installation ID: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVariantB = RemoteConfigService().showNewFeature;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Installation ID')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Firebase Installation ID is:'),
              SelectableText(
                _installationId,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getFirebaseInstallationId,
                child: Text('Refresh ID'),
              ),
              Text(
                isVariantB ? "Variante B" : "Variante A",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isVariantB ? Colors.red : Colors.blue,
                ),
                onPressed: () async {
                  print('Button clicked!');
                  await FirebaseAnalytics.instance.logEvent(
                    name: 'test_action_clicked',
                    parameters: {'variant': isVariantB ? 'B' : 'A'},
                  );
                  print(
                    "Event sent. Button clicked in variant ${isVariantB ? 'B' : 'A'}!",
                  );
                },
                child: const Text(
                  'Klick mich',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isVariantB = RemoteConfigService().showNewFeature;

    return Scaffold(
      appBar: AppBar(title: const Text('A/B Test Demo')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isVariantB ? "Variante B" : "Variante A",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: isVariantB ? Colors.red : Colors.blue,
              ),
              onPressed: () {
                FirebaseAnalytics.instance.logEvent(
                  name: 'test_action_clicked',
                  parameters: {'variant': isVariantB ? 'B' : 'A'},
                );
                print("Button clicked in variant ${isVariantB ? 'B' : 'A'}!");
              },
              child: const Text(
                'Klick mich',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
