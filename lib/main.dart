import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:mech_app/firebase_options.dart';
import 'package:mech_app/provider/userprovider.dart';
import 'package:provider/provider.dart';
import 'pages/Auth/Login_Page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ChangeNotifierProvider(
      create: (context) => UserProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
