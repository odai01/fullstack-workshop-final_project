import 'package:flutter/material.dart';

// import 'package:workshop_project_template/screens/add_post_screen.dart';
// import 'package:workshop_project_template/screens/auth_screen.dart';

import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'social network platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightGreen),
        useMaterial3: true,
      ),
      home:  HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
