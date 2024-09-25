import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_firebase/firebase_options.dart';
import 'package:flutter_firebase/pages/home.dart';

Future<void> main() async {
  // Assurez-vous que les widgets Flutter sont correctement initialisés
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisez Firebase avec les options par défaut
  await Firebase.initializeApp(options: DefaultFirebaseOptions.web);
  
  // Lancez l'application Flutter
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Web',
      theme: _buildAppTheme(),
      home: const HomePage(),
    );
  }

  // Méthode pour construire le thème de l'application
  ThemeData _buildAppTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
    );
  }
}
