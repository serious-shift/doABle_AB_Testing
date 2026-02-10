import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';
import 'src/core/services/remote_config_service.dart';
import 'src/features/home/screens/todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  try {
    String id = await FirebaseInstallations.instance.getId();
    print("--------------------------------------------------");
    print("MEINE TEST ID: $id");
    print("--------------------------------------------------");
  } catch (e) {
    print("Error fetching Firebase Installation ID: $e");
  }

  await RemoteConfigService().initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase ToDo List Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const TodoListScreen(),
    );
  }
}
