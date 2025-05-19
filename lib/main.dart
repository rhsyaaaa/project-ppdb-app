// ignore_for_file: unused_import

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ppdb_app/core/routing/app_route.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

Future  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>( 
      stream: FirebaseAuth.instance.authStateChanges(),
       builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final GoRouter customrouter = GoRouter(
            initialLocation: snapshot.data != null ? '/home' : '/login',
            routes: appRoute
          );
          return MaterialApp.router(
            title:"simple_app",
            debugShowCheckedModeBanner: false,
            routerConfig: customrouter,

          );
        } else {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(

                ),
              ),
            ),
          );
        }
      },);

  }
}