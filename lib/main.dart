import 'package:dotenv/dotenv.dart';
import 'package:flutter/material.dart';
import 'package:quarkus_api_front/views/login_view.dart';


void main() {
  var env = DotEnv(includePlatformEnvironment: true)..load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Front-end Quarkus API',
      theme: ThemeData(colorSchemeSeed: Colors.green, useMaterial3: false),
      home: const LoginView(),
    );
  }
}
