import 'package:auth/auth_provider/auth_provider.dart';
import 'package:auth/screens/signin.dart';
import 'package:auth/screens/signup.dart';
import 'package:auth/screens/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(create: (_) => AuthProvider(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wealth Heels Auth',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/verify': (_) => const VerifyEmailScreen(email: ''), // placeholder
      },
    );
  }
}
