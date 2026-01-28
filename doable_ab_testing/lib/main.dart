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

  String id = await FirebaseInstallations.instance.getId();
  print("MEINE FIREBASE INSTALLATION ID: $id");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: const TestScreen());
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
