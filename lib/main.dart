import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wordle/firebaseConfig.dart';
import 'package:flutter_wordle/home.dart';

Future<void> main() async {
  //initialize firebase
  WidgetsFlutterBinding.ensureInitialized();
  if ((kIsWeb || Platform.isAndroid || Platform.isIOS) && !kDebugMode) {
    await Firebase.initializeApp(options: optionsFirebase);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Desafio da palavra',
      theme: ThemeData.dark().copyWith(
          // primarySwatch: Colors.grey,
          ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Desafio da palavra'),
    );
  }
}
