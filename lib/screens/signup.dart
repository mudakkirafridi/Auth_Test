import 'package:auth/auth_provider/auth_provider.dart';
import 'package:auth/screens/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen();

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  void signup() async {
  final provider = Provider.of<AuthProvider>(context, listen: false);
  final email = emailController.text.trim();
  try {
    await provider.signup(
      email: email,
      password: passwordController.text.trim(),
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
    );

    // Redirect to email verification screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => VerifyEmailScreen(email: email),
      ),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
  }
}


  @override
  Widget build(BuildContext context) {
    final loading = context.watch<AuthProvider>().isLoading;
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(controller: firstNameController, decoration: InputDecoration(labelText: 'First Name')),
            TextField(controller: lastNameController, decoration: InputDecoration(labelText: 'Last Name')),
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password')),
            const SizedBox(height: 16),
            loading ? CircularProgressIndicator() : ElevatedButton(onPressed: signup, child: Text("Signup")),
          ],
        ),
      ),
    );
  }
}
